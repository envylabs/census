class Question < ActiveRecord::Base

  belongs_to :data_group, :inverse_of => :questions
  acts_as_list :scope => :data_group
  
  has_many :choices, :dependent => :destroy, :inverse_of => :question
  accepts_nested_attributes_for :choices, :reject_if => lambda { |a| a[:value].blank? }, :allow_destroy => true
  
  has_many :answers, :dependent => :destroy
  
  validates_presence_of :prompt,
                        :data_group
                 
  def sql_transform(column_name = '?')
    data_type_definition.sql_transform.call(column_name)
  end
  
  def format_data(data)
    data_type_definition.format_data.call(data)
  end
  
  def validate_data(data)
    data_type_definition.validate_data.call(data)
  end
  
  def to_s(data)
    format_data(data).to_s
  end
  
  def find_answers_matching(value)
    answers.find(:all, :conditions => conditions_for(value), :include => :user)
  end
  
  def restrict_values?
    choices.present? && !other?
  end


  private
  
  
  def data_type_definition
    Census::DataType.find(data_type) || Census::DataType.find('String')
  end
  
  def conditions_for(value)
    if value.kind_of?(Range) || value.kind_of?(Array)
      ["#{sql_transform('data')} IN (?)", value]
    else
      ["#{sql_transform('data')} = #{sql_transform}", value]
    end
  end
  
end
