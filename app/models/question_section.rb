# -*- encoding : utf-8 -*-
class QuestionSection < ActiveRecord::Base
  belongs_to :question_type
  has_many :questions
end
