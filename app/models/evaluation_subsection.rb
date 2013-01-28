# -*- encoding : utf-8 -*-
class EvaluationSubsection < ActiveRecord::Base
  belongs_to :evaluation_section
  has_many :evaluation_questions
  
  def mondai_list
  	Array.new
  end
end
