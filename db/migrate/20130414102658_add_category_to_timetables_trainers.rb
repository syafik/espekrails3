class AddCategoryToTimetablesTrainers < ActiveRecord::Migration
  def change
    add_column :timetables_trainers, :category, :integer
  end
end
