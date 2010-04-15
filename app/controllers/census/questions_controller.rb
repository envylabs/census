class Census::QuestionsController < ApplicationController
  
  def sort
    group = DataGroup.find(params[:data_group_id])
    question_positions = params[:question].to_a
    group.questions.each_with_index do |question, i|
      question.position = question_positions.index(question.id.to_s) + 1
      question.save
    end
    render :text => 'ok'
  end

end
