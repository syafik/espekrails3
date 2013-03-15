class AddFasilitatorRateToTrainers < ActiveRecord::Migration
  def change
    add_column :trainers, :fasilitator_rate, :decimal, :precision => 10, :scale => 2
  end
end
