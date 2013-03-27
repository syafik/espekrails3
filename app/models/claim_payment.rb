class ClaimPayment < ActiveRecord::Base
  belongs_to :timetable
  belongs_to :trainer
  belongs_to :category_trainer
  validates :total_approved, :numericality => true, :allow_nil => true, :allow_blank => true
end