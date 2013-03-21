# -*- encoding : utf-8 -*-
class EvaluationTruefalse < ActiveRecord::Base
  set_primary_key :id
  belongs_to :evaluation_question
end
