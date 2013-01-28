# -*- encoding : utf-8 -*-
class CourseLocation < ActiveRecord::Base
    has_many :course
	
	validates_presence_of :description
	validates_uniqueness_of :description,
							:on			  => :create,
							:message  => "sudah wujud."
	
	#validates_length_of :code,	:maximum =>20,
	#							:message => "tidak melebihi 20 aksara."
										
	validates_length_of :description,	:maximum =>250,
										:message => "tidak melebihi 250 aksara."
end
