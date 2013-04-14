# -*- encoding : utf-8 -*-
class Trainer < ActiveRecord::Base

	belongs_to :profile
	
	has_many :topics, :dependent => :nullify

	#has_and_belongs_to_many :expertises
	has_and_belongs_to_many :courses
  has_many :timetables_trainers, dependent: :destroy
	has_many :timetables, through: :timetables_trainers
	has_and_belongs_to_many :course_implementations
  has_many :claim_payment
	

end
