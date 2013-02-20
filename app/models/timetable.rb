# -*- encoding : utf-8 -*-
class Timetable < ActiveRecord::Base
    belongs_to :course_implementation
    
    has_and_belongs_to_many :facilities
    has_and_belongs_to_many :trainers
	
	has_many :evaluation_trainer_rankings
	
	validates_presence_of :date, :topic, :time_start, :time_end
end
