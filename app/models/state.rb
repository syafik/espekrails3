# -*- encoding : utf-8 -*-
class State < ActiveRecord::Base
  has_many :profiles
  has_many :places
  has_many :relatives

  validates_presence_of :code, :message => "[Kod Negeri Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Keterangan Kod Sudah Wujud]"
end
