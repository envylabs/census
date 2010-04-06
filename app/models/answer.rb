class Answer < ActiveRecord::Base

  belongs_to :question, :inverse_of => :answers
  belongs_to :user, :inverse_of => :answers
  
  validates_presence_of :question,
                        :user
                        
  validate :ensure_valid_choice
  validate :ensure_valid_data_type
  validate :check_multiple_answers
  
  named_scope :for_user, lambda { |user| { :conditions => {:user_id => user.id} } }
  
  def formatted_data
    question.format_data(self.data)
  end

  def to_s
    question.to_s(self.data)
  end
  
  
  private
  
  
  def ensure_valid_choice
    return if question.blank? || data.blank?
    errors.add_to_base("Invalid choice for #{question.prompt}") if question.restrict_values? && !question.choices.map(&:value).include?(self.data)
  end
  
  def ensure_valid_data_type
    return if question.blank? || data.blank?
    message = question.validate_data(data)
    errors.add_to_base("#{question.prompt} #{message}") if message
  end
  
  def check_multiple_answers
    return if question.blank? || user.blank?
    errors.add_to_base("Only one answer allowed for #{question.prompt}") if new_record? && question.answers.for_user(user).size > 0 && !question.multiple?
  end
  
end
