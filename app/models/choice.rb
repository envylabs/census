class Choice < ActiveRecord::Base

  belongs_to :question, :inverse_of => :choices
  acts_as_list :scope => :question
  default_scope :order => :position
  
  validates_presence_of :value,
                        :question
  
end
