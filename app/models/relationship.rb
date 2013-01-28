# -*- encoding : utf-8 -*-
class Relationship < ActiveRecord::Base
  has_many :relatives

  validates_presence_of :description, :message => "[Keterangan Hubungan Waris Perlu Diisi]"
  validates_uniqueness_of :description, :on => :create, :message => "[Keterangan Hubungan Waris Sudah Wujud]"
end
