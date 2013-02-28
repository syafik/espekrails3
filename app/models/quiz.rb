# -*- encoding : utf-8 -*-
class Quiz < ActiveRecord::Base
  belongs_to :course_implementation
  has_many :quiz_questions, :order => "id"
  has_many :quiz_answers
  belongs_to :course
  belongs_to :course_department
  belongs_to :quiz_type
end
