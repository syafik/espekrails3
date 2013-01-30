# -*- encoding : utf-8 -*-
class PostsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    today = Time.new
    @posts = Post.where("timeopen < '#{today}' AND timeclose > '#{today}'").paginate(:per_page => 50, :page => params[:page])
  end

  def list_all
    @posts = Post.paginate(:per_page => 50, :page => params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    today = Time.new
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    tomorrow = today + (60 * 60 * 24 * 14)
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
  end

  def create
    @post = Post.new(params[:post])
    @post.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    
    @post.profile_id = session[:user].profile.id
    if @post.save
      flash[:notice] = 'Pengumuman/Berita Telah Ditambah.'
      redirect_to :action => 'list_all'
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
     if @post.timeopen != nil
	 today = @post.timeopen
     else
	today = Time.new
     end
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
     if @post.timeclose != nil
	tomorrow = @post.timeclose
     else
	tomorrow = today + (60 * 60 * 24 * 14)
     end
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year

  end

  def update
    @post = Post.find(params[:id])
    @post.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Pengumuman/Berita Telah Dikemaskini.'
      redirect_to :action => 'list_all'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to :action => 'list_all'
  end
end
