require 'test_helper'

class StringQuestionTest < ActiveSupport::TestCase

  context "A StringQuestion" do
    
    setup do
      @question = Factory(:string_question)
    end
    
    subject { @question }

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
  
end
