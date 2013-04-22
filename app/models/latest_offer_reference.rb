# -*- encoding : utf-8 -*-
class LatestOfferReference < ActiveRecord::Base
    set_primary_key :id
    belongs_to :course_department
end
