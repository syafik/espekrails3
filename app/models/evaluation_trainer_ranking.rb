# -*- encoding : utf-8 -*-
class EvaluationTrainerRanking < ActiveRecord::Base
  set_primary_key :id
  belongs_to :topic
  belongs_to :trainer
  belongs_to :evaluation_question
end
