class AddMarkahToQuizAnswers < ActiveRecord::Migration
  def change
    add_column :quiz_answers, :markah, :integer, :default => 0
  end
end
