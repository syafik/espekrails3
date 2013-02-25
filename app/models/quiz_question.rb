# -*- encoding : utf-8 -*-
class QuizQuestion < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :quiz_type
  has_many :quiz_answers
  has_many :quiz_truefalses
  has_many :quiz_subjectives
  has_many :quiz_objectives
#  file_column :file, :store_dir => "/aplikasi/www/instun/public/quiz_question/file"
  
  #validates_presence_of :quiz_type_id, :message => "[Format Jawapan Perlu Diisi]"
end
