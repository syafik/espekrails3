# -*- encoding : utf-8 -*-
class EvaluationAnswer < ActiveRecord::Base
  belongs_to :evaluation_question
  belongs_to :profile
  belongs_to :course_application
  belongs_to :course_implementation
end
