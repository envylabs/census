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

    should_validate_presence_of     :prompt,
                                    :data_group
    
    should_allow_mass_assignment_of :data_type,
                                    :prompt,
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
    
    context "with String data type" do

      setup do
        @question.data_type = 'String'
      end
      
      should "return a default sql transform" do
        assert_equal "?", @question.sql_transform
      end

      context "with answers" do

        setup do
          @answer1 = Factory(:answer, :question => @question, :data => 'findme')
          @answer2 = Factory(:answer, :question => @question, :data => 'dont_findme')
          @answer3 = Factory(:answer, :question => @question, :data => 'findme_too')        
        end

        should "find answers matching a given string" do
          assert @question.find_answers_matching('findme').include?(@answer1)
        end

        should "not find answers not matching the given string" do
          assert !@question.find_answers_matching('findme').include?(@answer2)
        end

        should "find answers matching an array of strings" do
          result = @question.find_answers_matching(['findme', 'findme_too'])
          assert result.include?(@answer1)
          assert result.include?(@answer3)
          assert !result.include?(@answer2)
        end

      end

    end

    context "with Number data type" do

      setup do
        @question.data_type = 'Number'
      end

      should "return an integer sql transform" do
        assert_equal "CAST(? AS SIGNED INTEGER)", @question.sql_transform
      end
      
      context "with answers" do

        setup do
          @answer1 = Factory(:answer, :question => @question, :data => '123')
          @answer2 = Factory(:answer, :question => @question, :data => '125')
          @answer3 = Factory(:answer, :question => @question, :data => '127')
        end

        should "find answers matching a given string" do
          assert @question.find_answers_matching('123').include?(@answer1)
        end

        should "not find answers not matching the given string" do
          assert !@question.find_answers_matching('123').include?(@answer2)
        end

        should "find answers matching a given number" do
          assert @question.find_answers_matching(123).include?(@answer1)
        end

        should "not find answers not matching the given number" do
          assert !@question.find_answers_matching(123).include?(@answer2)
        end

        should "find answers in a given range" do
          result = @question.find_answers_matching(123..126)
          assert result.include?(@answer1)
          assert result.include?(@answer2)
          assert !result.include?(@answer3)
        end

      end

    end

  end
      
end
