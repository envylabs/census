require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase

  context "A Choice" do
    
    setup do
      @choice = Factory(:choice)
    end
    
    subject { @choice }

    should_belong_to                :question
    
    should_validate_presence_of     :value,
                                    :question

    should_allow_mass_assignment_of :value
    
    should_act_as_list
    
  end
  
  context 'A Choice with a Group' do

    setup do
      @movie_question  = Factory(:question, :prompt => 'Favorite Movie')

      @titanic_movie  = Factory(:choice, :value => 'Titanic', :group => 'Drama',
        :question => @movie_question)

      @avatar_movie   = Factory(:choice, :value => 'Avatar', :group => 'Adventure',
        :question => @movie_question)

      @avatar_movie   = Factory(:choice, :value => 'The Last Airbender', :group => 'Adventure',
        :question => @movie_question)
    end

    should 'belong to that group' do
      assert_equal 'Drama', @titanic_movie.group
      assert_equal 'Adventure', @avatar_movie.group
    end

    should 'return all from a group' do
      assert_equal 1, @movie_question.choices.from_group('Drama').size
      assert_equal 2, @movie_question.choices.from_group('Adventure').size
      assert_equal 0, @movie_question.choices.from_group('Comedy').size
    end

  end

end
