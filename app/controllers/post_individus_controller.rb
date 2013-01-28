# -*- encoding : utf-8 -*-
class PostIndividusController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list_all
    @post_individu_pages, @post_individus = paginate :post_individus, :per_page => 50
  end

  def list
    today = Time.new
    @post_individu_pages, @post_individus = paginate :post_individus, :per_page => 50, :conditions => "user_id = '#{session[:user].id}' AND timeopen < '#{today}' AND timeclose > '#{today}'"
  end

  def show
    @post_individu = PostIndividu.find(params[:id])
  end

  def new
    @post_individu = PostIndividu.new
    @students = User.find(:all, :conditions => "verified = '1' and login != 'admin'", :order => "name")
    today = Time.new
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    tomorrow = today + (60 * 60 * 24 * 14)
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
 
  end

  def create
    @post_individu = PostIndividu.new(params[:post_individu])
    @post_individu.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post_individu.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    @post_individu.profile_id = session[:user].profile.id
    if @post_individu.save
      flash[:notice] = 'Pengumuman/Berita Telah Ditambah.'
      redirect_to :action => 'list_all'
    else
      render :action => 'new'
    end
  end

  def edit
    @post_individu = PostIndividu.find(params[:id])
    @students = User.find(:all, :conditions => "verified = '1' and login != 'admin'", :order => "name")
    if @post_individu.timeopen != nil
	   today = @post_individu.timeopen
    else
	   today = Time.new
    end
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    if @post_individu.timeclose != nil
	   tomorrow = @post_individu.timeclose
    else
	   tomorrow = today + (60 * 60 * 24 * 14)
    end
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
  
  end

  def update
    @post_individu = PostIndividu.find(params[:id])
    @post_individu.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post_individu.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
  
    if @post_individu.update_attributes(params[:post_individu])
      flash[:notice] = 'Pengumuman/Berita Telah Dikemaskini.'
      redirect_to :action => 'list_all'
    else
      render :action => 'edit'
    end
  end

  def destroy
    PostIndividu.find(params[:id]).destroy
    redirect_to :action => 'list_all'
  end
end
