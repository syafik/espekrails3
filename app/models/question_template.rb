# -*- encoding : utf-8 -*-
class QuestionTemplate < ActiveRecord::Base
  has_many :questions
  has_many :course_evaluations
  has_and_belongs_to_many :course_implementations
end
