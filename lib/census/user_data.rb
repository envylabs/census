module Census
  class UserData

    def initialize(user, data_group = nil)
      @user = user
      
      if data_group
        @questions = {}
        define_question_methods(data_group)
      else
        @data_groups = Hash.new { |h,v| h[v] = {} }
        define_data_group_methods
      end
    end
    
    def [](key)
      if @data_groups
        @data_groups[key]
      else
        @user.first_answer_for(@questions[key]).formatted_data if @questions[key]
      end
    end

    def []=(key, value)
      if @data_groups
        @data_groups[key] = value
      else
        @user.first_answer_for(@questions[key]).update_attribute(:data, @questions[key].format_data(value).to_s) if @questions[key]
      end
    end
    
    
    private
    
    
    def define_data_group_methods
      DataGroup.all.each do |group|
        @data_groups[group.name] = Census::UserData.new(@user, group)
        
        (class << self; self; end).class_eval do
          define_method group.name.parameterize.underscore do
            @data_groups[group.name]
          end
        end
      end
    end
    
    def define_question_methods(data_group)
      data_group.questions.each do |question|
        @questions[question.prompt] = question
        
        (class << self; self; end).class_eval do
          define_method question.prompt.parameterize.underscore do
            @user.first_answer_for(question).formatted_data
          end

          define_method "#{question.prompt.parameterize.underscore}=" do |value|
            @user.first_answer_for(question).update_attribute(:data, question.format_data(value).to_s)
          end
        end
      end
    end

  end
end
