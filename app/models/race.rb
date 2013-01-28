# -*- encoding : utf-8 -*-
class Race < ActiveRecord::Base
  has_many :profiles

  validates_presence_of :code, :message => "[Kod Bangsa Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Keterangan Kod Sudah Wujud]"
end
