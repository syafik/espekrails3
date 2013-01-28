# -*- encoding : utf-8 -*-
class CourseDepartmentsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @course_department_pages, @course_departments = paginate :course_departments, :per_page => 10
  end

  def show
    @course_department = CourseDepartment.find(params[:id])
  end

  def new
    @course_department = CourseDepartment.new
  end

  def create
    @course_department = CourseDepartment.new(params[:course_department])
    if @course_department.save
      flash[:notice] = 'CourseDepartment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @course_department = CourseDepartment.find(params[:id])
  end

  def update
    @course_department = CourseDepartment.find(params[:id])
    if @course_department.update_attributes(params[:course_department])
      flash[:notice] = 'CourseDepartment was successfully updated.'
      redirect_to :action => 'show', :id => @course_department
    else
      render :action => 'edit'
    end
  end

  def destroy
    CourseDepartment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
