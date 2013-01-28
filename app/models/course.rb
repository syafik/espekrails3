# -*- encoding : utf-8 -*-
class Course < ActiveRecord::Base
	belongs_to :course_field
	belongs_to :course_type
	belongs_to :course_status	
	belongs_to :place
	belongs_to :course_location
	belongs_to :course_department
	#belongs_to :student
	#belongs_to :courses_personal
	
	has_and_belongs_to_many :methodologies
	has_and_belongs_to_many :trainers

	has_and_belongs_to_many :prerequisites,
							:class_name  => "Course",
	                        :join_table  => "prerequisites",
							:foreign_key => "course_id",
							:association_foreign_key => "prerequisite_course_id"

	
	has_one :course_implementation
	has_many :course_applications
	has_many :quizzes
	
    validates_presence_of :course_field,
                          :message => "^masukkan bidang kursus."

	validates_presence_of :name,
                          :message => '^ Sila masukkan kursus.'
    							
    validates_numericality_of :fee,
  							  :message => "^ Sila masukkan nombor sahaja."

	#validates_format_of :code,
	#					:with				=> /^\w+$/,
	#					:message    => "^ Sila kod kursus tidak sah."													

	#length													
    #validates_length_of :code,	:maximum =>10,
	#					:message => "^ Sila tidak melebihi 10 aksara."
    
    
end
