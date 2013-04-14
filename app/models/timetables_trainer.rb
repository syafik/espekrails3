class TimetablesTrainer < ActiveRecord::Base
  attr_accessible :timetable, :trainer, :category
  belongs_to :timetable
	belongs_to :trainer
end
