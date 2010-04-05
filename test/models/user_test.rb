require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should_have_many                    :answers, :dependent => :destroy
  should_accept_nested_attributes_for :answers
  should_allow_mass_assignment_of     :answers_attributes

end
