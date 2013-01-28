# -*- encoding : utf-8 -*-
class MainController < ApplicationController
  before_filter :login_required
  respond_to :html
  def index
    @roles = Role.all
    @user = User.find(44)
#    session[:user] = @user
    @userole = @user.roles
  end
 
  def home
  end
 
end
