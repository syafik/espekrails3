# -*- encoding : utf-8 -*-
class Expertise < ActiveRecord::Base
  set_primary_key "id"
  belongs_to :trainer
  belongs_to :profile
end
