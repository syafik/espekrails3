# -*- encoding : utf-8 -*-
class PenggunaController < ApplicationController
  layout "standard-layout"
  def login
    case @request.method
      when :post
      if @session[:user] = User.authenticate(@params[:user_login], @params[:user_password])

        #flash['notice']  = "Login successful"
        redirect_back_or_default :action => "welcome"
      else
        flash.now['notice']  = "Login unsuccessful"

        @login = @params[:user_login]
      end
    end
  end
  
  def signup
    @user = User.new(@params[:user])
    @user.role_ids = params[:role_ids] if @params[:role_ids]
    @roles = Role.find_all
    if @request.post? and @user.save
      #@session[:user] = User.authenticate(@user.login, @params[:user][:password])
      @session[:user] = User.authenticate(@params[:user_login], @params[:user][:password])
      flash['notice']  = "Signup successful"
      redirect_back_or_default :action => "welcome"
    end      
  end  
  
  def change_password
   @profile = Profile.find(params[:id])
   @user = @session['user']
   @session['message'] = nil
   case @request.method
      when :post
        unless @user.password_check?(@params['old_password'])
         @session['message'] = 'You have introduced a wrong password!'
        else
         unless @params['new_password'] == @params['new_password_confirmation']
          @session['message'] = 'Your password and password confirmation dont match!'
         else
          @session['message'] = 'Your passord was changed successfully!' if @user.change_password(@params['new_password'])
         end
        end
        redirect_back_or_default :controller => "pengguna", :action => "change_password" 
      end
  end
   
  def logout
    @session[:user] = nil
    redirect_to :controller=> 'pengguna', :action => "login"
  end
    
  def welcome
    redirect_to :controller=> 'main'
  end
  
end
