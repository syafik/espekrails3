# -*- encoding : utf-8 -*-
class Training < ActiveRecord::Base
  belongs_to :profile
  belongs_to :course_implementation
end
