# -*- encoding : utf-8 -*-
class EvaluationSubsection < ActiveRecord::Base
  set_primary_key :id
  belongs_to :evaluation_section
  has_many :evaluation_questions
  
  def mondai_list
  	Array.new
  end
end
