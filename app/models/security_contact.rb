# -*- encoding : utf-8 -*-
class SecurityContact < ActiveRecord::Base
  set_primary_key :id
  validates_presence_of :name
  validates_presence_of :email

end
