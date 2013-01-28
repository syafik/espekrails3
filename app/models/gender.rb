# -*- encoding : utf-8 -*-
class Gender < ActiveRecord::Base
  has_many :profiles

  validates_presence_of :code, :message => "[Kod Jantina Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Kod Jantina Sudah Wujud]"
end
