class AddMarkahToQuizQuestion < ActiveRecord::Migration
  def change
    add_column :quiz_questions, :markah, :integer
  end
end
