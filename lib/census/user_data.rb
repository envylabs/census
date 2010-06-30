module Census
  class UserData

    def initialize(user, data_group = nil)
      @user = user
      @data_group = data_group
      reload
    end
    
    def reload
      if @data_group
        @questions = []
        define_question_methods(@data_group)
      else
        @data_groups = []
        define_data_group_methods
      end
    end
    
    def group_name
      @data_group.name if @data_group
    end
    
    def [](key)
      if @data_groups
        find_data_group(key)
      else
        answer_for(find_question(key))
      end
    end

    def []=(key, value)
      if @data_groups
        raise ArgumentError, "Can't be invoked on a Data Group"
      else
        set_answer_for(find_question(key), value)
      end
    end

    def each_pair
      self.keys.each{ |key| yield key, self.send(key.parameterize.underscore.to_sym) }
    end
    
    
    protected
    
    
    def keys
      if @data_groups
        @data_groups.map(&:group_name)
      else
        @questions.map(&:prompt)
      end
    end
        
    
    private

    
    def find_data_group(name)
      @data_groups.select {|group| group.group_name == name}.first
    end
    
    def find_question(prompt)
      @questions.select {|question| question.prompt == prompt}.first
    end

    def answer_for(question)
      if question
        if question.multiple?
          @user.all_answers_for(question).map(&:formatted_data)
        else
          @user.first_answer_for(question).formatted_data
        end
      end
    end

    def set_answer_for(question, value)
      if question
        if question.multiple? && value.kind_of?(Array)
          @user.all_answers_for(question).each { |a| a.destroy }
          value.each { |v| @user.answers.build(:question => question, :data => v) }
        else
          @user.first_answer_for(question).update_attribute(:data, question.format_data(value).to_s)
        end
      end
    end
        
    def define_data_group_methods
      DataGroup.all.each do |group|
        @data_groups << Census::UserData.new(@user, group)
        
        (class << self; self; end).class_eval do
          define_method group.name.parameterize.underscore do
            find_data_group(group.name)
          end
        end
      end
    end
    
    def define_question_methods(data_group)
      data_group.questions.each do |question|
        @questions << question
        
        (class << self; self; end).class_eval do
          define_method question.prompt.parameterize.underscore do
            answer_for(question)
          end

          define_method "#{question.prompt.parameterize.underscore}=" do |value|
            set_answer_for(question, value)
          end
        end
      end
    end

  end
end
