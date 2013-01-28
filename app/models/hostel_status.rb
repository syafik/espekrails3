# -*- encoding : utf-8 -*-
class HostelStatus < ActiveRecord::Base
    has_many :hostel
  
    validates_presence_of :description
	validates_uniqueness_of :description,
							:on			  => :create,
							:message  => "sudah wujud."
	
	validates_length_of :description,	:maximum =>100,
										:message => "tidak melebihi 100 aksara."

end
