# -*- encoding : utf-8 -*-
class PlaceType < ActiveRecord::Base
  has_many :places
end
