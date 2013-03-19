class CreateCategoryTrainers < ActiveRecord::Migration
  def up
    create_table :category_trainers do |t|
      t.string  :name,       :null => false
    end
  end

  def down
    drop_table :category_trainers
  end
end
