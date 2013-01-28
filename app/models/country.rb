# -*- encoding : utf-8 -*-
class Country < ActiveRecord::Base
  has_many :places
  has_many :relatives
  has_many :qualifications

  validates_presence_of :code, :message => "[Kod Negara Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Kod Negara Sudah Wujud]"
end
