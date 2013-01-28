# -*- encoding : utf-8 -*-
class FavouritePlace < ActiveRecord::Base
	belongs_to :place
	belongs_to :course_department
end
