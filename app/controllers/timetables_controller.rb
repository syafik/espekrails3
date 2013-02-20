# -*- encoding : utf-8 -*-
class TimetablesController < ApplicationController
  layout "standard-layout"

  def initialize
    @courses = Course.find(:all, :order=>"name")
    @course_implementations = CourseImplementation.find(:all, :order=>"id")
    @profiles = Profile.all
    @facilities = Facility.all
    
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")    
  end
  
  def index
    redirect_to :action => 'list'
  end

  def list
    #  @timetables = Timetable.find_all_by_course_implementation_id(21)
    render  layout: "standard-layout"
  end

  def timetable_for_user
    redirect_to :action => 'list'
  end

  def show
    @timetable = Timetable.find(params[:id])
    render :layout => "standard-layout"

  end

  def new
    @timetable = Timetable.new
    @timetable.date = params[:date]
    @timetable.course_implementation_id = params[:course_implementation_id]
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    render :layout => "standard-layout"
  end

  def create
    @timetable = Timetable.new(params[:timetable])
    @timetable.time_start = params[:start_hour]+":"+params[:start_minute]
    @timetable.time_end = params[:end_hour]+":"+params[:end_minute]
	
    #render :text => params[:timetable][:trainer_ids]  and return
    #@timetable.trainer_ids = params[:timetable][:trainer_ids] if params[:timetable][:trainer_ids]
    #@timetable.facilities = Facility.find(params[:facility_ids]) if params[:facility_ids]
    if @timetable.save
      ids = @timetable.trainers.collect{|x| x.id }.join(",")
      Timetable.find_by_sql("DELETE FROM timetables_trainers WHERE timetable_id =#{@timetable.id} AND trainer_id IN (#{ids})")
      params[:timetable][:trainer_ids].each do |tr|
        @timetable.trainers << Trainer.find(tr)
      end
      @timetable.save
      prepare_update_course_implementation(@timetable)
      #      Timetable.find_by_sql("INSERT INTO timetables_trainers(timetable_id,trainer_id) values(#{@timetable.id},(#{params[:timetable][:trainer_ids].join(",") })) ")
      
      flash[:notice] = 'Jadual waktu berjaya ditambah'
      #redirect_to :action => 'list', :id => @timetable.course_implementation_id
    else
      render :action => 'new'
    end
  end

  def edit
    @timetable = Timetable.find(params[:id])
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    render :layout => "standard-layout"
  end

  def update
    @timetable = Timetable.find(params[:id])
    @timetable.time_start = params[:start_hour]+":"+params[:start_minute]
    @timetable.time_end = params[:end_hour]+":"+params[:end_minute]
    @timetable.trainers = Trainer.find(params[:trainer_ids]) if params[:trainer_ids]            
    @timetable.facilities = Facility.find(params[:facility_ids]) if params[:facility_ids]        
    if @timetable.update_attributes(params[:timetable])
      prepare_update_course_implementation(@timetable)
      #flash[:notice] = 'Timetable was successfully updated.'
      #redirect_to :action => 'list', :id => @timetable, :course_id => @timetable.course_id
    else
      render :action => 'edit', :id => @timetable, :course_implementation_id => @timetable.course_implementation_id
    end
  end

  def destroy
    Timetable.find(params[:id]).destroy
    #redirect_to :action => 'list', :course_id => @timetable.course_id
  end

  private
  def prepare_update_course_implementation(timetable)
    begin
      if timetable.time_end > timetable.course_implementation.timetables.order("time_start").last.time_end
        timetable.course_implementation.update_attribute(:time_end, timetable.time_end)
      end
    rescue
    end
  end
end
