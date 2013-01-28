# -*- encoding : utf-8 -*-
class CoursesTrainer < ActiveRecord::Base
	belongs_to :timetable
	belongs_to :trainer
end
