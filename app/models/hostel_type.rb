# -*- encoding : utf-8 -*-
class HostelType < ActiveRecord::Base
    has_many :hostel
  
    validates_presence_of :code, :description
	validates_uniqueness_of :code, :description,
							:on			  => :create,
							:message  => "sudah wujud."
	
	validates_length_of :code,	:maximum =>100,
										:message => "tidak melebihi 10 aksara."
	
	validates_length_of :description,	:maximum =>100,
										:message => "tidak melebihi 100 aksara."

end
