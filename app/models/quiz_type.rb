# -*- encoding : utf-8 -*-
class QuizType < ActiveRecord::Base
  has_many :quiz_questions
  has_many :quizzes
end
