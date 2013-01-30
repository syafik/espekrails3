# -*- encoding : utf-8 -*-
class CourseLocationsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @course_locations = CourseLocation.paginate(:per_page => 100, :page => params[:page]).order("description ASC")
  end

  def show
    @course_location = CourseLocation.find(params[:id])
  end

  def new
    @course_location = CourseLocation.new
  end

  def create
    @course_location = CourseLocation.new(params[:course_location])
    if @course_location.save
      flash[:notice] = 'Lokasi telah ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @course_location = CourseLocation.new
  end

  def create_popup
    @course_location = CourseLocation.new(params[:course_location])
    if @course_location.save
      #flash[:notice] = 'CourseLocation was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end
  

  def edit
    @course_location = CourseLocation.find(params[:id])
  end

  def update
    @course_location = CourseLocation.find(params[:id])
    if @course_location.update_attributes(params[:course_location])
      flash[:notice] = 'CourseLocation was successfully updated.'
      redirect_to :action => 'show', :id => @course_location
    else
      render :action => 'edit'
    end
  end

  def destroy
    CourseLocation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
