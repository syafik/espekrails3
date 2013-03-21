# -*- encoding : utf-8 -*-
class CategoryTrainer < ActiveRecord::Base
  has_many :course_implementation
end
