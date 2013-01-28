# -*- encoding : utf-8 -*-
class Place < ActiveRecord::Base
  acts_as_tree :order => "code"
  
  belongs_to :country
  belongs_to :state
  has_many :employments
  has_many :profiles
  has_many :place_contacts
  
  validates_uniqueness_of :code, :on => :create, :message => "[Kod Jabatan Telah Wujud]"
  validates_presence_of :name, :message => "[Nama Jabatan/Pejabat Perlu Diisi]"
  validates_presence_of :code, :message => "[Kod Jabatan/Pejabat Perlu Diisi]"
end
