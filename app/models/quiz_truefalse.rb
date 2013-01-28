# -*- encoding : utf-8 -*-
class QuizTruefalse < ActiveRecord::Base
  belongs_to :quiz_question
end
