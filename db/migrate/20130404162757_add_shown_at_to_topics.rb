class AddShownAtToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :shown_at, :datetime
  end
end
