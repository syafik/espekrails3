# -*- encoding : utf-8 -*-
class EvaluationQuestion < ActiveRecord::Base
  belongs_to :evaluation
  belongs_to :evaluation_section
  belongs_to :evaluation_subsection
  belongs_to :evaluation_type
  has_many :evaluation_answers
  has_many :evaluation_subjectives
  has_one :evaluation_trainer_ranking
  has_one :evaluation_ranking
  has_one :evaluation_truefalse
  
  validates_presence_of :evaluation_type_id, :message => "[Format Jawapan Perlu Diisi]"
  
  def student_answer(ca_id)
	ans = EvaluationAnswer.find_by_sql("select answer,answer_comment from evaluation_answers where evaluation_question_id=#{self.id} and course_application_id=#{ca_id}")
	if ans
		return ans.first
	else
		return 0
	end
  end
  
  def sum_trainer_ranking
  	sum = 0
	for ea in self.evaluation_answers
		next if ea.answer == nil
		sum = sum + ea.answer
	end
	return sum
  end

  def sum_ranking
  	sum = 0
	for ea in self.evaluation_answers
		sum = sum + ea.answer
	end
	return sum
  end

end
