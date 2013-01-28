# -*- encoding : utf-8 -*-
class Expertise < ActiveRecord::Base
  belongs_to :trainer
  belongs_to :profile
end
