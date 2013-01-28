# -*- encoding : utf-8 -*-
class PostCoursesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    today = Time.new
    @post_courses = PostCourse.find_by_sql("select p.id as p_id, c.id as c_id, p.title, p.post, p.updated_on, p.timeopen, p.timeclose, p.profile_id, p.course_implementation_id from post_courses p JOIN course_applications c ON p.course_implementation_id = c.course_implementation_id where c.profile_id = '#{session[:user].profile.id}' AND p.timeopen < '#{today}' and p.timeclose > '#{today}'")
  end

  def list_all
    @post_course_pages, @post_courses = paginate :post_courses, :per_page => 50
  end

  def show
    @post_course = PostCourse.find(params[:id])
  end

  def new
    @post_course = PostCourse.new
    @students = CourseApplication.find(:all, :select => 'distinct course_implementation_id')
    today = Time.new
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    tomorrow = today + (60 * 60 * 24 * 14)
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
  end

  def create
    @post_course = PostCourse.new(params[:post_course])
    @post_course.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post_course.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    
    @post_course.profile_id = session[:user].profile.id
    if @post_course.save
      flash[:notice] = 'Pengumuman/Berita Telah Ditambah.'
      redirect_to :action => 'list_all'
    else
      render :action => 'new'
    end
  end

  def edit
    @post_course = PostCourse.find(params[:id])
    @students = CourseApplication.find(:all, :select => 'distinct course_implementation_id')
    if @post_course.timeopen != nil
	   today = @post_course.timeopen
    else
	   today = Time.new
    end
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    if @post_course.timeclose != nil
	   tomorrow = @post_course.timeclose
    else
	   tomorrow = today + (60 * 60 * 24 * 14)
    end
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
  
  end

  def update
    @post_course = PostCourse.find(params[:id])
    @post_course.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @post_course.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    
    if @post_course.update_attributes(params[:post_course])
      flash[:notice] = 'Pengumuman/Berita Telah Dikemaskini.'
      redirect_to :action => 'list_all'
    else
      render :action => 'edit'
    end
  end

  def destroy
    PostCourse.find(params[:id]).destroy
    redirect_to :action => 'list_all'
  end
end
