# -*- encoding : utf-8 -*-
class ScaleType < ActiveRecord::Base
  has_many :scales
  validates_presence_of :description, :message => "[Keterangan Skala Perlu Diisi]"
end
