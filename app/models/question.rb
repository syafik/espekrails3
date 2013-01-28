# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  belongs_to :question_section
  belongs_to :question_template
  has_many :course_evaluations
  has_and_belongs_to_many :scale_types
end
