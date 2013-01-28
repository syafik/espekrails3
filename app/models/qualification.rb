# -*- encoding : utf-8 -*-
class Qualification < ActiveRecord::Base
  belongs_to :cert_level
  belongs_to :major
  belongs_to :country
  belongs_to :profile
end
