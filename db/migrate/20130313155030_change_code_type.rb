class ChangeCodeType < ActiveRecord::Migration
  def up
    change_column :places, :code, :string
  end

  def down
    change_column :places, :code, :string, :limit => 12
  end
end
