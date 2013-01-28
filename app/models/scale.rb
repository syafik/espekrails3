# -*- encoding : utf-8 -*-
class Scale < ActiveRecord::Base
  belongs_to :scale_type
  has_many :course_evaluations
end
