require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  context "An Answer" do
    
    setup do
      @answer = Factory(:answer)
    end
    
    subject { @answer }

    should_belong_to                :question
    should_belong_to                :user
  
    should_validate_presence_of     :question,
                                    :user
  
    should_allow_mass_assignment_of :data
    
    context "getting formatted data" do
      
      should "format strings" do
        a = Factory(:answer, :question => Factory(:question, :data_type => 'String'), :data => 'abc123')
        assert_equal 'abc123', a.formatted_data
      end
      
      should "format numbers" do
        a = Factory(:answer, :question => Factory(:question, :data_type => 'Number'), :data => '5389')
        assert_equal 5389, a.formatted_data
      end

      should "format booleans" do
        a = Factory(:answer, :question => Factory(:question, :data_type => 'Yes/No'), :data => '0')
        assert_equal false, a.formatted_data
        a.data = '1'
        assert_equal true, a.formatted_data
      end
      
    end
    
  end

end
