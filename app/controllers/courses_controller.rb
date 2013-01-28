# -*- encoding : utf-8 -*-
class CoursesController < ApplicationController
  def initialize
    @places = Place.find(:all, :order=>"id")
    @course_fields = CourseField.find(:all, :order=>"description")
    #@course_types = CourseType.find(:all, :order=>"id")    
    @course_locations = CourseLocation.find(:all, :order=>"id")    
    @course_statuses = CourseStatus.find(:all, :order=>"id")        
    #@profiles = Profile.find_all    
    #@methodologies = Methodology.find_all
    @course_departments = CourseDepartment.find(:all, :order=>"id")
    
    #@planning_years = Course.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from courses")    
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @course_pages, @courses = paginate :courses, :per_page => 10
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
	ccc = Course.find(52)
	@course.prerequisite_ids = [52]
    if @course.save
      flash[:notice] = 'Course was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash[:notice] = 'Course was successfully updated.'
      redirect_to :action => 'show', :id => @course
    else
      render :action => 'edit'
    end
  end

  def destroy
    Course.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
