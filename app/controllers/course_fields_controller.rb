# -*- encoding : utf-8 -*-
class CourseFieldsController < ApplicationController
  layout "standard-layout"
  
  def initialize
    @course_departments = CourseDepartment.find(:all, :order=>"id")
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @course_fields = CourseField.paginate(:per_page => 100, :page => params[:page]).order('course_department_id ASC')
  end

  def show
    @course_field = CourseField.find(params[:id])
  end

  def new
    @course_field = CourseField.new
  end

  def create
    @course_field = CourseField.new(params[:course_field])
    if @course_field.save
      flash[:notice] = 'CourseField was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @course_field = CourseField.new
  end

  def create_popup
    @course_field = CourseField.new(params[:course_field])
    if @course_field.save
      #flash[:notice] = 'CourseField was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end

  def edit
    @course_field = CourseField.find(params[:id])
  end

  def update
    @course_field = CourseField.find(params[:id])
    if @course_field.update_attributes(params[:course_field])
      flash[:notice] = 'CourseField was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    CourseField.find(params[:id]).destroy
    flash[:notice]='Course Field Successfully Deleted'
    redirect_to :action => 'list'
  rescue
    logger.error("Attempt to delete entry with reference key")
    flash[:notice] = 'Deletion Prohobited'
    redirect_to :action => 'list'
  end
end
