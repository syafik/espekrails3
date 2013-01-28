# -*- encoding : utf-8 -*-
class EvaluationTrainerRanking < ActiveRecord::Base
  belongs_to :topic
  belongs_to :trainer
  belongs_to :evaluation_question
end
