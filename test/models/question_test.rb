require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  context "A Question" do
    
    setup do
      @question = Factory(:question)
    end
    
    subject { @question }

    should_belong_to                :data_group
    should_have_many                :choices, :dependent => :destroy
    should_have_many                :answers, :dependent => :destroy

    should_act_as_list

    should_validate_presence_of     :prompt,
                                    :data_group
    
    should_allow_mass_assignment_of :prompt,
                                    :multiple,
                                    :other
                                    
    should_accept_nested_attributes_for :choices

    should "return a default sql transform" do
      assert '"?"', @question.sql_transform
    end
    
    context "with choices" do
      
      setup do
        @choice1 = Factory(:choice, :value => 'Choice 1', :question => @question)
        @choice2 = Factory(:choice, :value => 'Choice 2', :question => @question)
        @choice3 = Factory(:choice, :value => 'Choice 3', :question => @question)
      end
      
      should "allow answers that match the choices" do
        assert Factory.build(:answer, :question => @question, :data => 'Choice 1').valid?
        assert Factory.build(:answer, :question => @question, :data => 'Choice 3').valid?
      end
      
      should "not allow answers that don't match the choices" do
        assert !Factory.build(:answer, :question => @question, :data => 'Blah').valid?
      end

      context "that allows user-supplied 'other' answer" do
        
        setup do
          @question.update_attribute(:other, true)
        end
        
        should "allow answers that don't match the choices" do
          assert Factory.build(:answer, :question => @question, :data => 'Blah').valid?
        end
        
      end
      
    end
    
    context "that can't have multiple answers" do
      
      setup do
        @question.update_attribute(:multiple, false)
        @user = Factory(:user)
      end
      
      should "not be able to create multiple answers" do
        assert @question.answers.create(:data => 'Answer 1', :user => @user)
        assert !Factory.build(:answer, :question => @question, :data => 'Answer 2', :user => @user).valid?
      end
      
    end
    
    context "that can have multiple answers" do
      
      setup do
        @question.update_attribute(:multiple, true)
      end
      
      should "be able to create multiple answers" do
        assert @question.answers.create(:data => 'Answer 1')
        assert @question.answers.create(:data => 'Answer 2')
      end
      
    end
    
  end
  
end
