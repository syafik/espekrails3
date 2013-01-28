# -*- encoding : utf-8 -*-
class Title < ActiveRecord::Base
  has_many :profiles

  validates_presence_of :description, :message => "[Keterangan Gelaran Perlu Diisi]"
  validates_uniqueness_of :description, :on => :create, :message => "[Keterangan Gelaran Sudah Wujud]"
end
