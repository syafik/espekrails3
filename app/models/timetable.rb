# -*- encoding : utf-8 -*-
class Timetable < ActiveRecord::Base
    has_one :course_implementations
    
    has_and_belongs_to_many :facilities
    has_and_belongs_to_many :trainers
	
	has_many :evaluation_trainer_rankings
	
	validates_presence_of :date, :topic, :time_start, :time_end
end
