class Choice < ActiveRecord::Base

  belongs_to :question, :inverse_of => :choices
  default_scope :order => :position
  
  validates_presence_of :value,
                        :question
  
end
