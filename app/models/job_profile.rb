# -*- encoding : utf-8 -*-
class JobProfile < ActiveRecord::Base
  has_many :employments
  
  validates_presence_of :job_grade, :message => "[Keterangan Gred Perlu Diisi]"
  validates_numericality_of :ranking, :message => "[Ranking Dalam Format Integer]"
#  validates_uniqueness_of :job_grade, :on => :create, :message => "[Keterangan Gred Sudah Wujud]"
end
