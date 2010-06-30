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
      @question3 = Factory(:question, :prompt => 'Favorite Color', :multiple => true, :data_group => @data_group)
      @red = Factory(:choice, :question => @question3, :value => 'Red')
      @green = Factory(:choice, :question => @question3, :value => 'Green')
      @blue = Factory(:choice, :question => @question3, :value => 'Blue')
      @yellow = Factory(:choice, :question => @question3, :value => 'Yellow')

      @user = Factory(:user)
      Factory(:answer, :question => @question1, :data => 'Brown', :user => @user)
      Factory(:answer, :question => @question2, :data => '150', :user => @user)
      Factory(:answer, :question => @question3, :data => 'Blue', :user => @user)
      Factory(:answer, :question => @question3, :data => 'Green', :user => @user)
      @user.reload
    end
    
    context 'using auto-generated methods' do
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.census_data.physical_attributes.hair_color
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.census_data.physical_attributes.weight
      end

      should 'return an array of values for questions with multiple answers' do
        assert_equal ['Blue', 'Green'], @user.census_data.physical_attributes.favorite_color
      end
      
    end

    context 'using data group and question strings' do
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.census_data['Physical Attributes']['Hair Color']
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.census_data['Physical Attributes']['Weight']
      end
      
      should 'return an array of values for questions with multiple answers' do
        assert_equal ['Blue', 'Green'], @user.census_data['Physical Attributes']['Favorite Color']
      end

    end
    
    context 'using expose_census_data' do
      
      setup do
        @user.class.expose_census_data('Physical Attributes', 'Hair Color', :hair_color)
        @user.class.expose_census_data('Physical Attributes', 'Weight', :weight)
        @user.class.expose_census_data('Physical Attributes', 'Favorite Color', :favorite_color)
      end
      
      should 'return string values for string data types' do
        assert_equal 'Brown', @user.hair_color
      end
    
      should 'return integer values for numeric data types' do
        assert_equal 150, @user.weight
      end
            
      should 'return an array of values for questions with multiple answers' do
        assert_equal ['Blue', 'Green'], @user.favorite_color
      end

    end

    context 'using each_pair' do
      
      should 'retrieve data groups and their question lists when called directly on census_data' do
        @user.census_data.each_pair do |key, value|
          assert_contains ['Physical Attributes'], key
          assert value.kind_of?(Census::UserData)
        end
      end

      should 'retrieve pairs of questions and answers when called for a data group' do
        @user.census_data['Physical Attributes'].each_pair do |key, value|
          assert_contains ['Hair Color', 'Weight', 'Favorite Color'], key
          assert_equal 'Brown', value if key == 'Hair Color'
          assert_equal 150, value if key == 'Weight'
          assert_equal ['Blue', 'Green'], value if key == 'Favorite Color'
        end
      end
    
    end
    
  end

  context 'Setting answers' do
    
    setup do
      @data_group = Factory(:data_group, :name => 'Physical Attributes')
      @question1 = Factory(:question, :prompt => 'Hair Color', :data_group => @data_group)
      @question2 = Factory(:question, :prompt => 'Weight', :data_type => 'Number', :data_group => @data_group)
      @question3 = Factory(:question, :prompt => 'Favorite Color', :multiple => true, :data_group => @data_group)
      @red = Factory(:choice, :question => @question3, :value => 'Red')
      @green = Factory(:choice, :question => @question3, :value => 'Green')
      @blue = Factory(:choice, :question => @question3, :value => 'Blue')
      @yellow = Factory(:choice, :question => @question3, :value => 'Yellow')

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

      should 'accept arrays for questions that allow multiple answers' do
        @user.census_data.physical_attributes.favorite_color = ['Yellow', 'Red']
        assert_equal ['Yellow', 'Red'], @user.all_answers_for(@question3).map(&:formatted_data)
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
      
      should 'accept arrays for questions that allow multiple answers' do
        @user.census_data["Physical Attributes"]["Favorite Color"] = ['Yellow', 'Red']
        assert_equal ['Yellow', 'Red'], @user.all_answers_for(@question3).map(&:formatted_data)
      end
      
    end
    
    context 'using expose_census_data' do
      
      setup do
        @user.class.expose_census_data('Physical Attributes', 'Hair Color', :hair_color)
        @user.class.expose_census_data('Physical Attributes', 'Weight', :weight)
        @user.class.expose_census_data('Physical Attributes', 'Favorite Color', :favorite_color)
      end
      
      should 'allow string values for string data types' do
        @user.hair_color = 'Brown'
        assert_equal 'Brown', @user.first_answer_for(@question1).formatted_data
      end
    
      should 'allow integer values for numeric data types' do
        @user.weight = 210
        assert_equal 210, @user.first_answer_for(@question2).formatted_data
      end
            
      should 'accept arrays for questions that allow multiple answers' do
        @user.favorite_color = ['Yellow', 'Red']
        assert_equal ['Yellow', 'Red'], @user.all_answers_for(@question3).map(&:formatted_data)
      end
      
    end
    
  end
  
  context 'Enumerating answers with each_pair' do
    
    setup do
      @data_group = Factory(:data_group)
      10.times {|i| Factory(:question, :prompt => i.to_s, :data_group => @data_group)}
      @user = Factory(:user)
    end
    
    should 'maintain the correct order for questions' do
      assert_equal ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
        @user.census_data[@data_group.name].each_pair {|key, value| key}
      
      @data_group.questions.first.move_to_bottom
      @user.census_data.reload
      
      assert_equal ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        @user.census_data[@data_group.name].each_pair {|key, value| key}
    end

  end

end
