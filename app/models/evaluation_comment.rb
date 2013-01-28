# -*- encoding : utf-8 -*-
class EvaluationComment < ActiveRecord::Base
  belongs_to :course_implementation
  belongs_to :profile
  belongs_to :course_application
end
