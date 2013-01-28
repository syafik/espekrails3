# -*- encoding : utf-8 -*-
class QuestionType < ActiveRecord::Base
  has_many :question_sections
end
