# -*- encoding : utf-8 -*-
class CourseField < ActiveRecord::Base
    has_many :course
	has_many :course_implementation
	
	belongs_to :course_department
	
	validates_presence_of :code, :description
	
	validates_uniqueness_of :code, :description,
								   :on			  => :create,
								   :message  => "sudah wujud."

	validates_length_of :code,	:maximum =>20,
								:message => "tidak melebihi 20 aksara."
										
	validates_length_of :description,	:maximum =>100,
										:message => "tidak melebihi 100 aksara."
end
