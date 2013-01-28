# -*- encoding : utf-8 -*-
class CourseDepartment < ActiveRecord::Base
    has_many :course
    has_many :course_fields

	has_and_belongs_to_many :favourites,
							:class_name  => "Place",
	                        :join_table  => "favourite_places",
							:foreign_key => "course_department_id",
							:association_foreign_key => "place_id"

	validates_presence_of :code, :message => "[Kod Bahagian Perlu Diisi]"
	validates_uniqueness_of :code, :on => :create, :message  => "[Kod Bahagian Sudah Wujud]"
	
    validates_length_of :code,	:maximum =>5,
								:message => "tidak melebihi 5 aksara."
										
	validates_length_of :description,	:maximum =>100,
										:message => "tidak melebihi 100 aksara."
end
