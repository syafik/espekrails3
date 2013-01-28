# -*- encoding : utf-8 -*-
class EvaluationSection < ActiveRecord::Base
  has_many :evaluation_questions
  has_many :evaluation_subsections, :order=> "id asc"
end
