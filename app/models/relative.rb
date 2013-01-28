# -*- encoding : utf-8 -*-
class Relative < ActiveRecord::Base
  belongs_to :relationship
  belongs_to :profile
  belongs_to :state
  belongs_to :country
end
