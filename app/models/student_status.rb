# -*- encoding : utf-8 -*-
class StudentStatus < ActiveRecord::Base
  has_many :course_applications
end
