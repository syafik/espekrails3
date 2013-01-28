# -*- encoding : utf-8 -*-
class FacilityCategory < ActiveRecord::Base
	has_many :facility_types
  
  #has_many :facility
  
  validates_presence_of :code, :description
	validates_uniqueness_of :code, :description,
							:on			  => :create,
							:message  => "sudah wujud."
	
	validates_length_of :code,	:maximum =>25,
								:message => "tidak melebihi 25 aksara."
										
	validates_length_of :description,	:maximum =>100,
										:message => "tidak melebihi 100 aksara."
end
