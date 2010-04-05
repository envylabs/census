require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase

  context "A Choice" do
    
    setup do
      @choice = Factory(:choice)
    end
    
    subject { @choice }

    should_belong_to                :question
    
    should_act_as_list

    should_validate_presence_of     :value,
                                    :question

    should_allow_mass_assignment_of :value
    
  end
  
end
