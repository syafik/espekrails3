# -*- encoding : utf-8 -*-
class Staff < ActiveRecord::Base

	belongs_to :profile
	belongs_to :course_department

	validates_presence_of :course_department

	def responsible_courses
		a = CourseImplementation.find(:all, :conditions=>"coordinator1=#{self.id} OR coordinator2=#{self.id}")
		a
	end

end
