# -*- encoding : utf-8 -*-
class AcctStatus < ActiveRecord::Base
  has_many :users

  validates_presence_of :description, :message => "[Keterangan Status Akaun Perlu Diisi]"
  validates_uniqueness_of :description, :on => :create, :message => "[Keterangan Status Akaun Sudah Wujud]"
end
