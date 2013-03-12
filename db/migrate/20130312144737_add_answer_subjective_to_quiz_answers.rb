class AddAnswerSubjectiveToQuizAnswers < ActiveRecord::Migration
  def change
    add_column :quiz_answers , :answer_subjective, :text
    add_column :quiz_answers , :answer_truefalse, :boolean
  end
end
