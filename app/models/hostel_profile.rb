# -*- encoding : utf-8 -*-
class HostelProfile < ActiveRecord::Base
  has_many :profiles
  has_many :hostels
end
