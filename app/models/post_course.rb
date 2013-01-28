# -*- encoding : utf-8 -*-
class PostCourse < ActiveRecord::Base
	belongs_to :course_implementation
	belongs_to :profile
end
