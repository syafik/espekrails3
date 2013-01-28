# -*- encoding : utf-8 -*-
class CertLevel < ActiveRecord::Base
  has_many :qualifications

  validates_presence_of :description, :message => "[Keterangan Peringkat Akademik Perlu Diisi]"
  validates_uniqueness_of :description, :on => :create, :message => "[Keterangan Peringkat Akademik Sudah Wujud]"
end
