class Census::ChoicesController < ApplicationController
  
  def sort
    group = DataGroup.find(params[:data_group_id])
    question = group.questions.find(params[:question_id])
    choice_positions = params[:choice].to_a
    question.choices.each_with_index do |choice, i|
      choice.position = choice_positions.index(choice.id.to_s) + 1
      choice.save
    end
    render :text => 'ok'
  end

end
