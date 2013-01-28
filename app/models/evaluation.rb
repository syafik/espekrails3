# -*- encoding : utf-8 -*-
class Evaluation < ActiveRecord::Base
  belongs_to :course_implementation
  belongs_to :course
  has_many :evaluation_questions
  
  def editable?
	if self.course_implementation.evaluation_answers.size > 0
		return false
	else
		return true
	end
  end
end
