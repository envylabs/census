require 'test_helper'

class DataGroupTest < ActiveSupport::TestCase

  should_have_many                    :questions, :dependent => :destroy
  should_accept_nested_attributes_for :questions

  should_validate_presence_of         :name

  should_act_as_list

end
