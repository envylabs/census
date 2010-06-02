require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should_have_many                    :answers, :dependent => :destroy
  should_accept_nested_attributes_for :answers
  should_allow_mass_assignment_of     :answers_attributes

  context 'Looking up answers' do
    
    setup do
      @data_group = Factory(:data_group, :name => 'Physical Attributes')
      @question1 = Factory(:question, :prompt => 'Hair Color', :data_group => @data_group)
      @question2 = Factory(:question, :prompt => 'Weight', :data_type => 'Number', :data_group => @data_group)

      @user = Factory(:user)
      @user.answers << Factory(:answer, :question => @question1, :data => 'Brown')
      @user.answers << Factory(:answer, :question => @question2, :data => '150')
    end
    
    context 'using auto-generated methods' do
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.census_data.physical_attributes.hair_color
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.census_data.physical_attributes.weight
      end
      
    end

    context 'using data group and question strings' do
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.census_data['Physical Attributes']['Hair Color']
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.census_data['Physical Attributes']['Weight']
      end
      
    end
    
    context 'using expose_census_data' do
      
      setup do
        @user.class.expose_census_data('Physical Attributes', 'Hair Color', :hair_color)
        @user.class.expose_census_data('Physical Attributes', 'Weight', :weight)
      end
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.hair_color
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.weight
      end
            
    end
    
  end

  context 'Setting answers' do
    
    setup do
      @data_group = Factory(:data_group, :name => 'Physical Attributes')
      @question1 = Factory(:question, :prompt => 'Hair Color', :data_group => @data_group)
      @question2 = Factory(:question, :prompt => 'Weight', :data_type => 'Number', :data_group => @data_group)

      @user = Factory(:user)
    end
    
    context 'using auto-generated methods' do
      
      should 'allow string values for string data types' do
        @user.census_data.physical_attributes.hair_color = 'Brown'
        assert_equal 'Brown', @user.first_answer_for(@question1).formatted_data
      end
    
      should 'allow integer values for numeric data types' do
        @user.census_data.physical_attributes.weight = 210
        assert_equal 210, @user.first_answer_for(@question2).formatted_data
      end
      
    end

    context 'using data group and question strings' do
      
      should 'allow string values for string data types' do
        @user.census_data["Physical Attributes"]["Hair Color"] = 'Brown'
        assert_equal 'Brown', @user.first_answer_for(@question1).formatted_data
      end
    
      should 'allow integer values for numeric data types' do
        @user.census_data["Physical Attributes"]["Weight"] = 210
        assert_equal 210, @user.first_answer_for(@question2).formatted_data
      end
      
    end
    
    context 'using expose_census_data' do
      
      setup do
        @user.class.expose_census_data('Physical Attributes', 'Hair Color', :hair_color)
        @user.class.expose_census_data('Physical Attributes', 'Weight', :weight)
      end
      
      should 'allow string values for string data types' do
        @user.hair_color = 'Brown'
        assert_equal 'Brown', @user.first_answer_for(@question1).formatted_data
      end
    
      should 'allow integer values for numeric data types' do
        @user.weight = 210
        assert_equal 210, @user.first_answer_for(@question2).formatted_data
      end
            
    end
    
  end
  
  context 'Enumerating answers' do
    
    setup do
      @data_group = Factory(:data_group, :name => 'Physical Attributes')
      @question1 = Factory(:question, :prompt => 'Hair Color', :data_group => @data_group)
      @question2 = Factory(:question, :prompt => 'Weight', :data_type => 'Number', :data_group => @data_group)

      @user = Factory(:user)
      @user.answers << Factory(:answer, :question => @question1, :data => 'Brown')
      @user.answers << Factory(:answer, :question => @question2, :data => '150')
    end
    
    should 'retrieve data groups and their question lists' do
      @user.census_data.each_pair do |key, value|
        assert_contains ['Physical Attributes'], key
        assert value.kind_of?(Census::UserData)
      end
    end
    
    should 'retrieve pairs of questions and answers for a data group' do
      @user.census_data['Physical Attributes'].each_pair do |key, value|
        assert_contains ['Hair Color', 'Weight'], key
        assert_equal 'Brown', value if key == 'Hair Color'
        assert_equal 150, value if key == 'Weight'
      end
    end

  end

end
