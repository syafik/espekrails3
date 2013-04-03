class CreateClaimPayments < ActiveRecord::Migration
  def up
    create_table :claim_payments do |t|
      t.integer  :trainer_id,       :null => false
      t.integer  :timetable_id,     :null => false
      t.decimal  :total_claim,      :precision => 10, :scale => 2
      t.decimal  :total_approved,   :precision => 10, :scale => 2
      t.string   :status,           :default => "sedang diproses"
      t.integer  :category_trainer_id
      t.decimal  :total_time,       :precision => 10, :scale => 2
      t.date     :timetable_date
    end
  end

  def down
    drop_table :claim_payments
  end
end
