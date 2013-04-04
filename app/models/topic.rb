# -*- encoding : utf-8 -*-
class Topic < ActiveRecord::Base
  belongs_to :course_implementation
	belongs_to :trainer
    	
	has_many :evaluation_trainer_rankings

  attr_accessor :shown_at
  
	validates :title, :presence => true
	
	def question_list
		list = self.evaluation_trainer_rankings.size
		a = self.evaluation_trainer_rankings.first.evaluation_question.evaluation_answers.size
		return a
	end
end
