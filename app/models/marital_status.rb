# -*- encoding : utf-8 -*-
class MaritalStatus < ActiveRecord::Base
  has_many :profiles

  validates_presence_of :code, :message => "[Kod Status Perkahwinan Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Keterangan Kod Status Perkahwinan Sudah Wujud]"
end
