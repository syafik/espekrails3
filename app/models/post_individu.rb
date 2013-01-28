# -*- encoding : utf-8 -*-
class PostIndividu < ActiveRecord::Base
  belongs_to :profile
  belongs_to :user
end
