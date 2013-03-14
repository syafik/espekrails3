# -*- encoding : utf-8 -*-
class EvaluationRanking < ActiveRecord::Base
  set_primary_key :id
  belongs_to :evaluation_question
end
