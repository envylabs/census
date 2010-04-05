require 'test_helper'

class NumberQuestionTest < ActiveSupport::TestCase

  context "A NumberQuestion" do
    
    setup do
      @question = Factory(:number_question)
    end
    
    subject { @question }

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
