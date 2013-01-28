# -*- encoding : utf-8 -*-
class HostelFacilityType < ActiveRecord::Base
    has_many :hostel_facility
	
	validates_presence_of :description
	validates_uniqueness_of :description,
							:on			  => :create,
							:message  => "sudah wujud."
	
	validates_length_of :description,	:maximum =>250,
										:message => "tidak melebihi 250 aksara."
end
