# -*- encoding : utf-8 -*-
class Religion < ActiveRecord::Base
  has_many :profiles
  
  validates_presence_of :code, :message => "[Kod Agama Perlu Diisi]"
  validates_uniqueness_of :code, :on => :create, :message => "[Kod Agama Sudah Wujud]"
end
