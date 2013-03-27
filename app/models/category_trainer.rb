# -*- encoding : utf-8 -*-
class CategoryTrainer < ActiveRecord::Base
  has_many :course_implementation
  has_many :claim_payment
end
