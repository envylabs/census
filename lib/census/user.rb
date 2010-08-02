module Census
  module User
    
    # Hook for all Census::User modules.
    #
    # If you need to override parts of Census::User,
    # extend and include à la carte.
    #
    # @example
    #   extend ClassMethods
    #   include InstanceMethods
    #   include Callbacks
    #
    # @see ClassMethods
    # @see InstanceMethods
    # @see Callbacks
    def self.included(model)
      model.extend(ClassMethods)

      model.send(:include, InstanceMethods)
      model.send(:include, Associations)
      model.send(:include, Callbacks)
      model.send(:include, Scopes)
    end

    module Associations
      # Hook for defining associations.
      def self.included(model)
        model.class_eval do
          has_many                      :answers, :dependent => :destroy, :inverse_of => :user
          accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:data].blank? }
        end
      end
    end

    module Callbacks
      # Hook for callbacks.
      #
      # empty answers are removed after_save.
      def self.included(model)
        model.class_eval do
          after_save :remove_empty_answers
        end
      end
    end

    module Scopes
      #
      # This scope can be used to find other users who have census answers in common with the
      # given user. The returned list is sorted such that users with the most answers in
      # common are at the beginning of the list.
      #
      def self.included(model)
        model.class_eval do
          named_scope :with_matching_census_answers, lambda { |user, limit|
            {
              :select => "DISTINCT users.*, COUNT(answers.id) AS census_match_score",
              :joins => "LEFT JOIN `answers` AS answers ON answers.user_id = users.id LEFT JOIN `answers` AS other_answers ON other_answers.user_id = #{user.id}", 
              :conditions => ['users.id <> ? AND answers.data = other_answers.data AND answers.question_id = other_answers.question_id', user.id],
              :group => 'users.id',
              :order => 'census_match_score DESC',
              :limit => limit
            }
          }
        end
      end
    end

    module InstanceMethods
      #
      # Returns this user's first answer for the given question, or a new empty
      # answer if the user has not answered the question.
      #
      def first_answer_for(question)
        answers.select {|a| a.question == question}.first || answers.build(:question => question, :data => '')
      end

      #
      # Returns an array of this user's answers for the given question. The returned
      # array will be empty if the user has not answered this question.
      #
      def all_answers_for(question)
        answers.select {|a| a.question == question}
      end

      #
      # Returns this user's answer for a specific choice under a multiple-choice
      # question, or a new empty answer if the user did not select the given choice.
      #
      def answer_for_choice(choice)
        answers.select {|a| a.question == choice.question && a.data == choice.value}.first || answers.build(:question => choice.question, :data => '')
      end
      
      #
      # Returns a Census::UserData object that can be used to retrieve this user's
      # answers.
      #
      def census_data
        @census_data ||= Census::UserData.new(self)
      end

      private

      #
      # After save callback, used to remove blank answers
      #
      def remove_empty_answers
        answers.each {|answer| answer.destroy if answer.data.blank? }
      end      
    end

    module ClassMethods
      #
      # Expose a census data value as an attribute on the model class
      #
      def expose_census_data(group, data, attribute)
        instance_eval do
          define_method attribute.to_s do
            self.census_data[group.to_s][data.to_s]
          end
          
          define_method "#{attribute.to_s}=" do |value|
            self.census_data[group.to_s][data.to_s] = value
          end
        end
      end
    end

  end
end
