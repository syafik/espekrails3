class AddCategoryTrainersIdToCourseImplementationsTrainers < ActiveRecord::Migration
  def change
    add_column :course_implementations_trainers, :category_trainer_id, :integer, :default => 1
  end
end
