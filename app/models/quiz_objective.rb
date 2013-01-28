# -*- encoding : utf-8 -*-
class QuizObjective < ActiveRecord::Base
  belongs_to :quiz_question
end
