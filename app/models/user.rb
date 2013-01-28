# -*- encoding : utf-8 -*-
require "search"
class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  has_and_belongs_to_many :roles
  # all logic has been moved into login_engine/lib/login_engine/authenticated_user.rb

  belongs_to :profile
  searches_on :name
  include LoginEngine::AuthenticatedUser
  include UserEngine::AuthorizedUser
  # Returns the full name of this user.
  def fullname
    "#{self.firstname} #{self.lastname}"
  end
end
