# -*- encoding : utf-8 -*-
class Reservation < ActiveRecord::Base
	belongs_to :course_implementation
    belongs_to :course
	belongs_to :staff
	validates_numericality_of :male_total, :female_total, :trainer_total, :message => "[Bilangan Dalam Format Integer]"
end
