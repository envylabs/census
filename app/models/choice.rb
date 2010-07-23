class Choice < ActiveRecord::Base

  belongs_to :question, :inverse_of => :choices

  acts_as_list
  default_scope :order => :position
  
  validates_presence_of :value,
                        :question

  named_scope :from_group, lambda{ |group_name| {
    :conditions => { :group => group_name }  }
  }

  
end
