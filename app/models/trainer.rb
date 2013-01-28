# -*- encoding : utf-8 -*-
class Trainer < ActiveRecord::Base

	belongs_to :profile
	
	has_many :topics

	#has_and_belongs_to_many :expertises
	has_and_belongs_to_many :courses
	has_and_belongs_to_many :timetables
	has_and_belongs_to_many :course_implementations
	

end
