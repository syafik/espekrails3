# -*- encoding : utf-8 -*-
class Attendance < ActiveRecord::Base
	belongs_to :course_application
end
