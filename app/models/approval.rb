# -*- encoding : utf-8 -*-
class Approval < ActiveRecord::Base
  has_many :course_applications
end
