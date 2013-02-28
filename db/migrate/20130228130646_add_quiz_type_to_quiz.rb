class AddQuizTypeToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :quiz_type_id, :integer
  end
end
