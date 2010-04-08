require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  context "Performing a search" do
    
    setup do
      @question1 = Factory(:question, :prompt => 'Hair Color')
      @question2 = Factory(:question, :prompt => 'Weight')
      
      @matching_user = Factory(:user)
      Factory(:answer, :user => @matching_user, :question => @question1, :data => 'Brown')
      Factory(:answer, :user => @matching_user, :question => @question2, :data => '150')

      @partial_match_user = Factory(:user)
      Factory(:answer, :user => @partial_match_user, :question => @question1, :data => 'Black')
      Factory(:answer, :user => @partial_match_user, :question => @question2, :data => '160')

      @non_matching_user = Factory(:user)
      Factory(:answer, :user => @non_matching_user, :question => @question1, :data => 'Blond')
      Factory(:answer, :user => @non_matching_user, :question => @question2, :data => '200')
    end
    
    should "find the matching user" do
      results = Census::Search.new(@question1 => 'Brown', @question2 => 145..165).perform
      assert results.include?(@matching_user)
    end
    
    should "not find the other users" do
      results = Census::Search.new(@question1 => 'Brown', @question2 => 145..165).perform
      assert !results.include?(@non_matching_user)
      assert !results.include?(@partial_match_user)
    end

    should "not find any users" do
      results = Census::Search.new(@question1 => 'Blue', @question2 => 145..165).perform
      assert results.empty?
    end
    
  end
  
end
