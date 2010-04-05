class Question < ActiveRecord::Base

  belongs_to :data_group, :inverse_of => :questions
  acts_as_list :scope => :data_group
  
  has_many :choices, :dependent => :destroy, :inverse_of => :question
  accepts_nested_attributes_for :choices, :reject_if => lambda { |a| a[:value].blank? }, :allow_destroy => true
  
  has_many :answers, :dependent => :destroy
  
  validates_presence_of :prompt,
                        :data_group

  def self.load_data_type(klass)
    @@question_types ||= []
    @@question_types << klass
  end
  
  def self.data_types
    @@question_types ||= [StringQuestion, NumberQuestion, BooleanQuestion]
    @@question_types.map {|klass| [klass.data_type_description, klass.name]}
  end
  
  def self.data_type_description
    ""
  end
  
  def data_type
    self.class.name
  end
  
  def data_type=(type)
    self[:type] = type
  end
    
  def sql_transform(column_name = '?')
    "#{column_name}"
  end
  
  def format_data(data)
    data
  end
  
  def validate_data(data)
    nil
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
  
  
  def conditions_for(value)
    if value.kind_of?(Range) || value.kind_of?(Array)
      ["#{sql_transform('data')} IN (?)", value]
    else
      ["#{sql_transform('data')} = #{sql_transform}", value]
    end
  end
  
end
