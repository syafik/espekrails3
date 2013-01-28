# -*- encoding : utf-8 -*-
class EvaluationType < ActiveRecord::Base
  has_many :evaluation_questions
end
