require 'test_helper'

class BooleanQuestionTest < ActiveSupport::TestCase

  context "A BooleanQuestion" do
    
    setup do
      @question = Factory(:boolean_question)
    end
    
    subject { @question }

    should "return a boolean sql transform" do
      assert_equal "CAST(? AS CHAR)", @question.sql_transform
    end

    context "with answers" do
      
      setup do
        @answer1 = Factory(:answer, :question => @question)
        @answer1.update_attribute(:data, false)
        @answer2 = Factory(:answer, :question => @question, :data => true)
      end
        
      should "find answers matching true" do
        assert @question.find_answers_matching(true).include?(@answer2)
      end

      should "not find answers not matching true" do
        assert !@question.find_answers_matching(true).include?(@answer1)
      end

      should "find answers matching false" do
        assert @question.find_answers_matching(false).include?(@answer1)
      end

      should "not find answers not matching false" do
        assert !@question.find_answers_matching(false).include?(@answer2)
      end
      
    end
    
  end
  
end
