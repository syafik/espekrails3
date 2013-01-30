# -*- encoding : utf-8 -*-
class CourseStatusesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @course_statuses = CourseStatus.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @course_status = CourseStatus.find(params[:id])
  end
  
  def new_popup
    @course_status = CourseStatus.new
  end

  def create_popup
    @course_status = CourseStatus.new(params[:course_status])
    if @course_status.save
      #flash[:notice] = 'CourseStatus was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end

  def new
    @course_status = CourseStatus.new
  end

  def create
    @course_status = CourseStatus.new(params[:course_status])
    if @course_status.save
      flash[:notice] = 'CourseStatus was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @course_status = CourseStatus.find(params[:id])
  end

  def update
    @course_status = CourseStatus.find(params[:id])
    if @course_status.update_attributes(params[:course_status])
      flash[:notice] = 'CourseStatus was successfully updated.'
      redirect_to :action => 'show', :id => @course_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    CourseStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
