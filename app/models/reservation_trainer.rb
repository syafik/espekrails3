# -*- encoding : utf-8 -*-
class ReservationTrainer < ActiveRecord::Base
	belongs_to :course_implementation
	belongs_to :staff
	belongs_to :trainer
end
