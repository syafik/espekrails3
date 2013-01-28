# -*- encoding : utf-8 -*-
class QuizAnswer < ActiveRecord::Base
  belongs_to :quiz_question
  belongs_to :profile
  belongs_to :course_application
  belongs_to :course_implementation
  belongs_to :quiz
end
