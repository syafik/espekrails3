# -*- encoding : utf-8 -*-
class District < ActiveRecord::Base
	belongs_to :state
end
