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
    end

  end
end
