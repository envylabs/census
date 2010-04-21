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
    
  end

end
