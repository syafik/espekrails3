# -*- encoding : utf-8 -*-
class CourseImplementationsController < ApplicationController
  #  require "pdf/writer"
  layout "standard-layout"

  def initialize
    @courses = Course.find(:all, :order=>"name")
    @places = Place.find(:all, :order=>"code ASC")
    @course_fields = CourseField.find(:all, :order=>"description")
    #@course_types = CourseType.find(:all, :order=>"id")    
    @course_locations = CourseLocation.find(:all, :order=>"description")    
    @course_statuses = CourseStatus.find(:all, :order=>"id")        
    #@profiles = Profile.find_all    
    @methodologies = Methodology.all
    @course_departments = CourseDepartment.find(:all, :order=>"id")
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")    
    #@list_dates = CourseImplementation.find_by_sql("SELECT * from vw_detailed_courses")    
  end

  def add_course_trainer
    @course_implementation = CourseImplementation.find(params[:id])
  end
  
  def add_timetable
    @course_implementation = CourseImplementation.find(params[:id])
  end
  
  def save_timetable
    @course_implementation = CourseImplementation.find(params[:id])
    if @course_implementation.update_attributes(params[:course_implementation])
      redirect_to :action => 'show_timetable', :id => @course_implementation
    end
  end
  
  def show_timetable
    @course_implementation = CourseImplementation.find(params[:id])
  end
  
  def show_timetable2
    @course_implementation = CourseImplementation.find(params[:id])
  end
  
  def delete_timetable
    @course_implementation = CourseImplementation.find(params[:id])
    delete = CourseImplementation.find_by_sql("UPDATE course_implementations SET file ='' where id ='#{@course_implementation.id}'")
    redirect_to :action => 'show_timetable', :id => @course_implementation
  end
  
  def add_course_trainer_refresh_opener
    add_course_trainer
    render :layout => "standard-layout"
  end

  def save_course_trainer
	
    @course_implementation = CourseImplementation.find(params[:id])
	
    @course_implementation.trainer_ids = []
    if params[:trainer_ids] and params[:trainer_ids].size > 0
      @course_implementation.trainer_ids = params[:trainer_ids]
    end
    redirect_to :action=>"add_course_trainer", :id=>@course_implementation
  end
  
  def save_course_trainer_refresh_opener
    @course_implementation = CourseImplementation.find(params[:id])
	
    @course_implementation.trainer_ids = []
    if params[:trainer_ids] and params[:trainer_ids].size > 0
      @course_implementation.trainer_ids = params[:trainer_ids]
    end
    redirect_to :action=>"add_course_trainer_refresh_opener", :id=>@course_implementation
  end

  def remove_course_trainer

  end

  def index
    #    list
    redirect_to :action => 'list'
  end
  
  def iklan
    @course_implementation_pages, @course_implementations = paginate :course_implementations, :per_page => 10
  end

  def test_list
    s = Staff.find(36)
    render :text => s.responsible_courses.size
  end

  def list
    #@course_implementation_pages, @course_implementations = paginate :course_implementations, :per_page => 100
    #@where_sql = " WHERE year_start=#{sch_year.to_i} #{sch_month} #{sch_dept}"

    params[:year_start] = Time.now.strftime("%Y") if !params[:year_start]

    if !params[:course_department_id]
  		if session[:user].profile.staff 
        params[:course_department_id] = session[:user].profile.staff.course_department_id.to_s
      end
    end

    @cond = Array.new()
    @cond.push("year_start="  +  params[:year_start])
    @cond.push("month_start=" +  params[:month_start]) unless params[:month_start].blank? 
    @cond.push("course_department_id=" +  params[:course_department_id]) unless params[:course_department_id].blank?

    @where_sql = @cond.join(" AND ")

    #params[:coordinator] = session[:user].profile.staff.id if !params[:coordinator]
    if !params[:coordinator]
      if session[:user].profile.staff
        params[:coordinator] = session[:user].profile.staff.id
      else
        params[:coordinator] = "0"
      end
    end

    if params[:coordinator] != "0"
      @where_sql += " AND ((coordinator1=#{params[:coordinator]}) OR (coordinator2=#{params[:coordinator]}) OR (ketua_program=#{params[:coordinator]}) OR (pen_ketua_program=#{params[:coordinator]}))"
      #else
      #	if session[:user].profile.staff
      #		stf_id = session[:user].profile.staff.id
      #		@where_sql += " AND (coordinator1=#{stf_id} OR coordinator2=#{stf_id})"
      #	end
    end


    params[:orderby] = "date_plan_start" if params[:orderby].blank?
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]

    @cimps = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE #{@where_sql} ORDER BY #{@orderby} #{params[:arrow]}")
    render :layout => "standard-layout" 
  end

  def list_public
    #@querys = CourseImplementation.find_by_sql("select * from vw_detailed_courses where date_plan_start > current_date ORDER BY year_start,month_start,day_start")
    params[:year_start] = Time.now.strftime("%Y") if !params[:year_start]

    if !params[:course_department_id]
      if session[:user] and session[:user].profile
        if session[:user].profile.staff
          params[:course_department_id] = session[:user].profile.staff.course_department_id.to_s
        end
      end
    end

    @cond = Array.new()
    @cond.push("year_start="  +  params[:year_start])
    @cond.push("month_start=" +  params[:month_start]) if params[:month_start] != nil
    @cond.push("course_department_id=" +  params[:course_department_id]) if params[:course_department_id] != nil

    @where_sql = @cond.join(" AND ")

    params[:coordinator] = "0"
    if params[:coordinator] != "0"
      @where_sql += " AND ((coordinator1=#{params[:coordinator]}) OR (coordinator2=#{params[:coordinator]}) OR (ketua_program=#{params[:coordinator]}) OR (pen_ketua_program=#{params[:coordinator]}))"
    end


    params[:orderby] = "date_plan_start" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]

    @querys = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE #{@where_sql} ORDER BY #{@orderby} #{params[:arrow]}")
  end

  def calendar
  
  end

  def calendar_public	
  end
  
  def calendar_user
    #@course_implementations = CourseImplementation.find(:all, :order=>"code")
  end
  
  def list_courses_from_today_to_future
    #@course_implementation_pages, @course_implementations = paginate :course_implementations, :per_page => 100
    #@course_implementations = CourseImplementation.find(:all, :conditions=>"date_plan_start > '2001-09-09' AND ")
    @course_implementations = CourseImplementation.find_by_sql("SELECT * from vw_detailed_courses WHERE date_plan_start > current_date AND course_status_id=1 ")
  end

  def search
    begin
    
      if params[:search_date]
        tarikh1 = params[:search_date].to_s
        tarikhi = tarikh1.split('/')
        d = tarikhi[0]
        m = tarikhi[1]
        y = tarikhi[2]
        tarikhii = m+"/"+d+"/"+y
      end
    
      sql = "SELECT * from vw_detailed_courses WHERE "
      where = "name ilike '%#{params[:search_name]}%'order by date_plan_start desc" if params[:search_name]
      where = "code ilike '%#{params[:search_code]}%' order by date_plan_start desc" if params[:search_code]
      where = "date_plan_start = '#{tarikhii}'order by date_plan_start desc" if params[:search_date]
	
      if where != nil
        @course_implementations = CourseImplementation.find_by_sql(sql + where)
      else
        @course_implementations = []
      end
	render :layout => "standard-layout"
    rescue
      flash['notice'] = 'Carian Tidak Sah'
      redirect_to :action => 'search'
    end
  end

  def search_for_user
    begin
    
      if params[:search_date]
        tarikh1 = params[:search_date].to_s
        tarikhi = tarikh1.split('/')
        d = tarikhi[0]
        m = tarikhi[1]
        y = tarikhi[2]
        tarikhii = m+"/"+d+"/"+y
      end
      sql = "SELECT * from vw_detailed_courses WHERE "
      where = "name ilike '%#{params[:search_name]}%' AND date_plan_start > current_date" if params[:search_name]
      where = "code ilike '%#{params[:search_code]}%' AND date_plan_start > current_date" if params[:search_code]
      where = "date_plan_start = '#{tarikhii}' " if params[:search_date]

      if where != nil
        where = where + " AND course_status_id=1"
        @course_implementations = CourseImplementation.find_by_sql(sql + where)
      else
        @course_implementations = []
      end
	
    rescue
      flash['notice'] = 'Carian Tidak Sah'
      redirect_to :action => 'search_for_user'
    end
  end

  def booking_hostel
    @course_implementation = CourseImplementation.find(params[:id])
    @course = @course_implementation.course
  end

  def show_public
    @course_implementation = CourseImplementation.find(params[:id])
    @course = @course_implementation.course
    list_bulans = CourseImplementation.find_by_sql("SELECT * from vw_detailed_courses WHERE id = #{@course_implementation.id}")
    for list_bulan in list_bulans
      @day_start = list_bulan.day_start
      @month_start = list_bulan.month_start
      @year_start = list_bulan.year_start
      @day_end = list_bulan.day_end
      @month_end = list_bulan.month_end
      @year_end = list_bulan.year_end
      @day_last = list_bulan.day_last
      @month_last = list_bulan.month_last
      @year_last = list_bulan.year_last
      @day_check = list_bulan.day_check
      @month_check = list_bulan.month_check
      @year_check = list_bulan.year_check
    end
  end

  def show
    @course_implementation = CourseImplementation.find(params[:id])
    @course_application = CourseApplication.find(:first,:conditions => ["profile_id = ? and course_implementation_id = ?",session[:user].profile_id, @course_implementation.id])
    @course = @course_implementation.course
    list_bulans = CourseImplementation.find_by_sql("SELECT * from vw_detailed_courses WHERE id = #{@course_implementation.id}")    
    for list_bulan in list_bulans
      @day_start = list_bulan.day_start
      @month_start = list_bulan.month_start
      @year_start = list_bulan.year_start
      @day_end = list_bulan.day_end
      @month_end = list_bulan.month_end
      @year_end = list_bulan.year_end
      @day_last = list_bulan.day_last
      @month_last = list_bulan.month_last
      @year_last = list_bulan.year_last
      @day_check = list_bulan.day_check
      @month_check = list_bulan.month_check
      @year_check = list_bulan.year_check
    end
  end

  def show_to_print
    show
  end

  def show_only_for_peserta
    show
  end

  def new
    @course = Course.new
    @course_implementation = CourseImplementation.new
    @course_implementation.course = @course
    render :layout => "standard-layout"
  end


  def create

    #workaround
    @day_start       = params[:day_start]
    @month_start     = params[:month_start]
    @year_start      = params[:year_start]

    @day_end         = params[:day_end]
    @month_end       = params[:month_end]
    @year_end        = params[:year_end]

    @day_check_in    = params[:@day_check_in]
    @month_check_in  = params[:@month_check_in]
    @year_check_in   = params[:@year_check_in]
    @hour_check_in   = params[:@hour_check_in]
    @minute_check_in = params[:@minute_check_in]
	  
    @day_check_out    = params[:@day_check_out]
    @month_check_out  = params[:@month_check_out]
    @year_check_out   = params[:@year_check_out]
    @hour_check_out   = params[:@hour_check_out]
    @minute_check_out = params[:@minute_check_out]

    @day_briefing    = params[:@day_briefing]
    @month_briefing  = params[:@month_briefing]
    @year_briefing   = params[:@year_briefing]
    @hour_briefing   = params[:@hour_briefing]
    @minute_briefing = params[:@minute_briefing]


    @day_apply_start   = params[:day_apply_start]
    @month_apply_start = params[:month_apply_start]
    @year_apply_start  = params[:year_apply_start]

	  @day_apply_end   = params[:day_apply_end]
    @month_apply_end = params[:month_apply_end]
    @year_apply_end  = params[:year_apply_end]
      
	  @day_check       = params[:day_check]
    @month_check     = params[:month_check]
    @year_check      = params[:year_check]

	  @day_evaluation_end   = params[:day_evaluation_end]
    @month_evaluation_end = params[:month_evaluation_end]
    @year_evaluation_end  = params[:year_evaluation_end]
	
	  @day_publish       = params[:day_publish]
    @month_publish     = params[:month_publish]
    @year_publish      = params[:year_publish]

    ##########

    @course_implementation = CourseImplementation.new(params[:course_implementation]) if params[:course_implementation]
	
    @course = Course.new(params[:course])
    @course.methodologies = Methodology.find(params[:methodology_ids]) if params[:methodology_ids]            
    @course.methodologies.names = params[:names] if params[:names]

    if @course.save
      @course_implementation.course = @course

      @course_implementation.date_publish     = params[:month_publish]+"/"+params[:day_publish]+"/"+params[:year_publish]
      @course_implementation.date_apply_start = params[:month_apply_start]+"/"+params[:day_apply_start]+"/"+params[:year_apply_start]
      @course_implementation.date_apply_end   = params[:month_apply_end]+"/"+params[:day_apply_end]+"/"+params[:year_apply_end]
      @course_implementation.date_check       = params[:month_check]+"/"+params[:day_check]+"/"+params[:year_check]
      @course_implementation.date_evaluation_end   = params[:month_evaluation_end]+"/"+params[:day_evaluation_end]+"/"+params[:year_evaluation_end]
      @course_implementation.date_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
      @course_implementation.date_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
      @course_implementation.date_plan_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
      @course_implementation.date_plan_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
      @course_implementation.time_start  = params[:time_start]
      @course_implementation.time_end    = params[:time_end]
      @course_implementation.check_in    = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
      @course_implementation.check_out   = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
      @course_implementation.briefing    = params[:month_briefing]+"/"+params[:day_briefing]+"/"+params[:year_briefing] + " " +params[:hour_briefing]+":"+params[:minute_briefing]
      #delete later, just to syncronize with older version
      @course_implementation.last_date = params[:month_apply_end]+"/"+params[:day_apply_end]+"/"+params[:year_apply_end]
      @course_implementation.check_date = params[:month_check]+"/"+params[:day_check]+"/"+params[:year_check]

      @course_implementation.created_by = session[:user].login

      if @course_implementation.save
        flash[:notice] = "Kursus berjaya ditambah."
        month = sprintf("%02d",params[:month_start].to_i)
		
        redirect_to("/course_implementations/list?planning_year=#{params[:start_year]}&planning_month=#{month}&course_department_id=#{@course.course_department_id}")

        params[:prerequisite_codes].size.times do |i|
          if params[:prerequisite_codes][i] != ""
            @pre = CourseImplementation.find_by_code(params[:prerequisite_codes][i])
            @course.prerequisites.push(@pre.course) if @pre
          end
        end
		
        #redirect_to :action => 'list'
        #render :text => @course_implementation.check_date
      else
        @course.destroy
        render :action => 'new'
      end
    else
      flash[:error]= "<font color=\"red\"><b>#{@course.valid?}</b></font><br>"
	                 
      render :action => 'new'
    end

  end

  def edit
    @course_implementation = CourseImplementation.find(params[:id])
    @course = @course_implementation.course   
    
    schedule = CourseImplementation.find(params[:id])
	  if !schedule.date_start
      @day_start   = schedule.date_plan_start.to_formatted_s(:my_format_day)
      @month_start = schedule.date_plan_start.to_formatted_s(:my_format_month)
      @year_start  = schedule.date_plan_start.to_formatted_s(:my_format_year)
	  else
      @day_start   = schedule.date_start.to_formatted_s(:my_format_day)
      @month_start = schedule.date_start.to_formatted_s(:my_format_month)
      @year_start  = schedule.date_start.to_formatted_s(:my_format_year)
	  end

	  if !schedule.date_end
      @day_end     = schedule.date_plan_end.to_formatted_s(:my_format_day)
      @month_end   = schedule.date_plan_end.to_formatted_s(:my_format_month)
      @year_end    = schedule.date_plan_end.to_formatted_s(:my_format_year)
	  else
      @day_end     = schedule.date_end.to_formatted_s(:my_format_day)
      @month_end   = schedule.date_end.to_formatted_s(:my_format_month)
      @year_end    = schedule.date_end.to_formatted_s(:my_format_year)
	  end

	  @day_check   = schedule.date_check.to_formatted_s(:my_format_day)   if schedule.date_check
    @month_check = schedule.date_check.to_formatted_s(:my_format_month) if schedule.date_check
    @year_check  = schedule.date_check.to_formatted_s(:my_format_year)  if schedule.date_check

	  @day_publish   = schedule.date_publish.to_formatted_s(:my_format_day)   if schedule.date_publish
	  @month_publish = schedule.date_publish.to_formatted_s(:my_format_month) if schedule.date_publish
	  @year_publish  = schedule.date_publish.to_formatted_s(:my_format_year)  if schedule.date_publish

	  @day_apply_start   = schedule.date_apply_start.to_formatted_s(:my_format_day)   if schedule.date_apply_start
	  @month_apply_start = schedule.date_apply_start.to_formatted_s(:my_format_month)   if schedule.date_apply_start
	  @year_apply_start  = schedule.date_apply_start.to_formatted_s(:my_format_year)   if schedule.date_apply_start

	  @day_apply_end   = schedule.date_apply_end.to_formatted_s(:my_format_day)   if schedule.date_apply_end
	  @month_apply_end = schedule.date_apply_end.to_formatted_s(:my_format_month)   if schedule.date_apply_end
	  @year_apply_end  = schedule.date_apply_end.to_formatted_s(:my_format_year)   if schedule.date_apply_end

	  @day_evaluation_end   = schedule.date_evaluation_end.to_formatted_s(:my_format_day)   if schedule.date_evaluation_end
	  @month_evaluation_end = schedule.date_evaluation_end.to_formatted_s(:my_format_month) if schedule.date_evaluation_end
	  @year_evaluation_end  = schedule.date_evaluation_end.to_formatted_s(:my_format_year)  if schedule.date_evaluation_end

	  @day_check_in   = schedule.check_in.to_formatted_s(:my_format_day)   if schedule.check_in
    @month_check_in = schedule.check_in.to_formatted_s(:my_format_month) if schedule.check_in
    @year_check_in  = schedule.check_in.to_formatted_s(:my_format_year)  if schedule.check_in
    @hour_check_in  = schedule.check_in.to_formatted_s(:my_format_hour)  if schedule.check_in
    @minute_check_in  = schedule.check_in.to_formatted_s(:my_format_minute)  if schedule.check_in


    @day_check_out   = schedule.check_out.to_formatted_s(:my_format_day)   if schedule.check_out
    @month_check_out = schedule.check_out.to_formatted_s(:my_format_month) if schedule.check_out
    @year_check_out  = schedule.check_out.to_formatted_s(:my_format_year)  if schedule.check_out
    @hour_check_out  = schedule.check_out.to_formatted_s(:my_format_hour)  if schedule.check_out
    @minute_check_out  = schedule.check_out.to_formatted_s(:my_format_minute)  if schedule.check_out
     
    @day_briefing   = schedule.briefing.to_formatted_s(:my_format_day)   if schedule.briefing
    @month_briefing = schedule.briefing.to_formatted_s(:my_format_month) if schedule.briefing
    @year_briefing  = schedule.briefing.to_formatted_s(:my_format_year)  if schedule.briefing
    @hour_briefing  = schedule.briefing.to_formatted_s(:my_format_hour)  if schedule.briefing
    @minute_briefing  = schedule.briefing.to_formatted_s(:my_format_minute)  if schedule.briefing
    render :layout => "standard-layout" 
  end

  def update
    #workaround
    @day_start       = params[:day_start]
    @month_start     = params[:month_start]
    @year_start      = params[:year_start]

    @day_end         = params[:day_end]
    @month_end       = params[:month_end]
    @year_end        = params[:year_end]
      
    @day_apply_start   = params[:day_apply_start]
    @month_apply_start = params[:month_apply_start]
    @year_apply_start  = params[:year_apply_start]

	  @day_apply_end   = params[:day_apply_end]
    @month_apply_end = params[:month_apply_end]
    @year_apply_end  = params[:year_apply_end]
      
	  @day_check       = params[:day_check]
    @month_check     = params[:month_check]
    @year_check      = params[:year_check]

	  @day_evaluation_end   = params[:day_evaluation_end]
    @month_evaluation_end = params[:month_evaluation_end]
    @year_evaluation_end  = params[:year_evaluation_end]
	
	  @day_publish       = params[:day_publish]
    @month_publish     = params[:month_publish]
    @year_publish      = params[:year_publish]

    @day_check_in    = params[:@day_check_in]
    @month_check_in  = params[:@month_check_in]
    @year_check_in   = params[:@year_check_in]
    @hour_check_in   = params[:@hour_check_in]
    @minute_check_in = params[:@minute_check_in]
	  
    @day_check_out    = params[:@day_check_out]
    @month_check_out  = params[:@month_check_out]
    @year_check_out   = params[:@year_check_out]
    @hour_check_out   = params[:@hour_check_out]
    @minute_check_out = params[:@minute_check_out]

    @day_briefing = params[:day_briefing]
    @month_briefing = params[:month_briefing]
    @year_briefing = params[:year_briefing]
    @hour_briefing = params[:hour_briefing]
    @minute_briefing = params[:minute_briefing]
    ##########
    
    @course_implementation = CourseImplementation.find(params[:id])
	  #@course_implementation.date_publish     = params[:month_publish]+"/"+params[:day_publish]+"/"+params[:year_publish]
	  @course_implementation.date_publish     = "#{params[:month_publish]}/#{params[:day_publish]}/#{params[:year_publish]}"
	  #@course_implementation.date_apply_start = params[:month_apply_start]+"/"+params[:day_apply_start]+"/"+params[:year_apply_start]
	  @course_implementation.date_apply_start = "#{params[:month_apply_start]}/#{params[:day_apply_start]}/#{params[:year_apply_start]}"
	  #@course_implementation.date_apply_end   = params[:month_apply_end]+"/"+params[:day_apply_end]+"/"+params[:year_apply_end]
	  @course_implementation.date_apply_end   = "#{params[:month_apply_end]}/#{params[:day_apply_end]}/#{params[:year_apply_end]}"
	  #@course_implementation.date_check       = params[:month_check]+"/"+params[:day_check]+"/"+params[:year_check]
	  @course_implementation.date_check       = "#{params[:month_check]}/#{params[:day_check]}/#{params[:year_check]}"
	  #@course_implementation.date_evaluation_end   = params[:month_evaluation_end]+"/"+params[:day_evaluation_end]+"/"+params[:year_evaluation_end]
	  @course_implementation.date_evaluation_end   = "#{params[:month_evaluation_end]}/#{params[:day_evaluation_end]}/#{params[:year_evaluation_end]}"
	  #@course_implementation.date_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
	  @course_implementation.date_start = "#{params[:month_start]}/#{params[:day_start]}/#{params[:year_start]}"
    #@course_implementation.date_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
    @course_implementation.date_end   = "#{params[:month_end]}/#{params[:day_end]}/#{params[:year_end]}"
	  #@course_implementation.date_plan_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
	  @course_implementation.date_plan_start = "#{params[:month_start]}/#{params[:day_start]}/#{params[:year_start]}"
	  #@course_implementation.date_plan_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
	  @course_implementation.date_plan_end   = "#{params[:month_end]}/#{params[:day_end]}/#{params[:year_end]}"
    @course_implementation.time_start  = params[:time_start]
    @course_implementation.time_end    = params[:time_end]

	  #@course_implementation.check_in    = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
	  @course_implementation.check_in    = "#{params[:month_check_in]}/#{params[:day_check_in]}/#{params[:year_check_in]} #{params[:hour_check_in]}:#{params[:minute_check_in]}"
	  #@course_implementation.check_out   = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
	  @course_implementation.check_out   = "#{params[:month_check_out]}/#{params[:day_check_out]}/#{params[:year_check_out]} #{params[:hour_check_out]}:#{params[:minute_check_out]}"
	  #@course_implementation.briefing    = params[:month_briefing]+"/"+params[:day_briefing]+"/"+params[:year_briefing] +  " " +params[:hour_briefing]+":"+params[:minute_briefing]
	  @course_implementation.briefing    = "#{params[:month_briefing]}/#{params[:day_briefing]}/#{params[:year_briefing]} #{params[:hour_briefing]}:#{params[:minute_briefing]}"

    @course = @course_implementation.course
    @course.methodologies = Methodology.find(params[:methodology_ids]) if params[:methodology_ids]

    @course.prerequisites = []
    unless params[:prerequisite_codes].blank?
      params[:prerequisite_codes].size.times do |i|
        if params[:prerequisite_codes][i] != ""
          @pre = CourseImplementation.find_by_code(params[:prerequisite_codes][i])
          @course.prerequisites.push(@pre.course) if @pre
        end
      end
    end
    @course.update_attributes(params[:course])
	    
    if @course_implementation.update_attributes(params[:course_implementation])
      #render :text => @course.id
      flash[:notice] = "Kursus telah dikemaskini."

      redirect_to :action => 'show', :id => @course_implementation, :course_id => @course
    else
      render :action => 'edit'
    end
  end

  def copy_and_new
		edit
  end

  def copy_and_create
		create
  end

  def open
    @course_implementation = CourseImplementation.find(params[:id])
    @course = Course.find(@course_implementation.course_id)
    if @course.update_attributes(:course_status_id => 1)
      flash[:notice] = "Status Kursus Dibuka"
      redirect_to :action => 'show', :id => @course_implementation, :course_id => @course
    end
  end

  def close
    @course_implementation = CourseImplementation.find(params[:id])
    @course = Course.find(@course_implementation.course_id)
    if @course.update_attributes(:course_status_id => 2)
      flash[:notice] = "Status Kursus Ditutup"
      redirect_to :action => 'show', :id => @course_implementation, :course_id => @course
    end
  end

  def postpone
    edit
  end

  def postpone_update
    #workaround
    @day_start       = params[:day_start]
    @month_start     = params[:month_start]
    @year_start      = params[:year_start]

    @day_end         = params[:day_end]
    @month_end       = params[:month_end]
    @year_end        = params[:year_end]
      
	  @day_apply_start   = params[:day_apply_start]
    @month_apply_start = params[:month_apply_start]
    @year_apply_start  = params[:year_apply_start]

	  @day_apply_end   = params[:day_apply_end]
    @month_apply_end = params[:month_apply_end]
    @year_apply_end  = params[:year_apply_end]
      
	  @day_check       = params[:day_check]
    @month_check     = params[:month_check]
    @year_check      = params[:year_check]

	  @day_evaluation_end   = params[:day_evaluation_end]
    @month_evaluation_end = params[:month_evaluation_end]
    @year_evaluation_end  = params[:year_evaluation_end]
	
	  @day_publish       = params[:day_publish]
    @month_publish     = params[:month_publish]
    @year_publish      = params[:year_publish]
    ##########
	  @course_implementation = CourseImplementation.find(params[:id])
    @course = Course.find(@course_implementation.course_id)

	  @course_implementation.date_publish     = params[:month_publish]+"/"+params[:day_publish]+"/"+params[:day_publish]
	  @course_implementation.date_apply_start = params[:month_apply_start]+"/"+params[:day_apply_start]+"/"+params[:year_apply_start]
	  @course_implementation.date_apply_end   = params[:month_apply_end]+"/"+params[:day_apply_end]+"/"+params[:year_apply_end]
	  @course_implementation.date_check       = params[:month_check]+"/"+params[:day_check]+"/"+params[:year_check]
	  @course_implementation.date_evaluation_end   = params[:month_evaluation_end]+"/"+params[:day_evaluation_end]+"/"+params[:year_evaluation_end]
	  @course_implementation.date_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
    @course_implementation.date_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
	  #@course_implementation.date_plan_start = params[:month_start]+"/"+params[:day_start]+"/"+params[:year_start]
	  #@course_implementation.date_plan_end   = params[:month_end]+"/"+params[:day_end]+"/"+params[:year_end]
    #@course_implementation.time_start  = params[:time_start]
    #@course_implementation.time_end    = params[:time_end]

    if @course_implementation.update_attributes(params[:course_implementation])
      #render :text => @course.id
      flash[:notice] = "Kursus telah ditangguhkan."
      redirect_to :action => 'show', :id => @course_implementation, :course_id => @course
    else
      render :action => 'postpone'
    end

  end

  
  def destroy
    CourseImplementation.find(params[:id]).destroy
    flash[:notice]='Course Successfully Deleted'
    redirect_to :action => 'list'
  rescue
    logger.error("Attempt to delete entry with reference key")
    flash[:notice] = 'Deletion Prohibited'
    redirect_to :action => 'list'
  end

  def edit_surat_iklan_select_pejabat
    @schedules = CourseImplementation.find_by_sql("select * from vw_detailed_courses where id =#{params[:id]} ")
    #if params[:course_department_id]
    if @schedules[0].course_department_id
      #@cdept = CourseDepartment.find(params[:course_department_id])
      @cdept = CourseDepartment.find(@schedules[0].course_department_id)
      @fav_places = Place.find_by_sql("select * from places join favourite_places on places.id=favourite_places.place_id where course_department_id=#{@cdept.id} order by code asc")
    else
      @fav_places = []
    end
	
    @place_pages, @places = paginate(:places, :per_page => 10000, :order_by => "code asc")
  end 

  def edit_surat_iklan_select_kursus
    render layout: "standard-layout"
  end 

  def edit_surat_iklan_la_apa_lagi
    @course_implementation = CourseImplementation.find(params[:surat_iklan_content][:course_implementation_id])
    @course = Course.find(@course_implementation.course_id)
    @surat_iklan_content = SuratIklanContent.find_by_course_implementation_id(@course_implementation.id)
	  if !@surat_iklan_content
		  @surat_iklan_content = SuratIklanContent.new
	  end
  end 
  
  def rujukan_kami
    @surats = SuratIklanContent.find(:all, :conditions => "course_department_id = #{params[:id]}")
  end
  
  def cetak_surat_iklan
    filename = "surat_iklan_"+ "#{params[:surat_iklan_content][:course_implementation_id]}.pdf"

    @signature = Signature.find_by_filename(params[:signature_file])
    if @signature
      @tandatangan_nama = @signature.person_name
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! {|e| e}.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama    = "                     "
      @tandatangan_jawatan = "                     "
    end

    gen_pdf_all_format_1 (filename) if params[:surat_iklan_content][:format_surat].to_i == 1 or params[:surat_iklan_content][:format_surat].to_i == 3
    gen_pdf_all_format_2 (filename) if params[:surat_iklan_content][:format_surat].to_i == 2 or params[:surat_iklan_content][:format_surat].to_i == 4
	
    course_implementation = CourseImplementation.find(params[:surat_iklan_content][:course_implementation_id])
    course = Course.find(course_implementation.course_id)
  
    rujukan = LatestLetterReference.find_by_course_department_id(course.course_department_id)
	
    if rujukan
      rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
    else
      rujukan = LatestLetterReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => params[:course_department_id])
      rujukan.save
    end
	
    params[:surat_iklan_content][:ref_no] = params[:rujukan_kami]
    params[:surat_iklan_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]

    ads_letter = SuratIklanContent.find_by_course_implementation_id(course_implementation.id)
    if ads_letter
      ads_letter.update_attributes(params[:surat_iklan_content])
    else
      new_ads_letter = SuratIklanContent.new(params[:surat_iklan_content])
      new_ads_letter.save!
    end
	
	
    #redirect_to("#{@request.relative_url_root}/public/pdf_certificate/" + filename)
    redirect_to("/surat/" + filename)
  end


  def show_pdf
    filename = "show.pdf"
    @course_implementation = CourseImplementation.find(params[:id])
    @course = @course_implementation.course   
    
    gen_show_pdf (filename)
    redirect_to("/surat/" + filename)
  end

  #################################################################################
  private
  def gen_pdf_all_format_1 (file)
    @font_size = 12
    header_image = "/aplikasi/www/instun/public/images/header800.jpg"
    pdf = PDF::Writer.new(:paper=>"A4")
    if params[:surat_iklan_content][:format_surat].to_i == 3
      pdf.margins_pt(0, 50, 36, 50)
    else
      pdf.margins_pt(36, 50, 36, 50)
    end
    @my_margin = pdf.absolute_top_margin - 30
    #pdf.select_font("Times-Roman")
    pdf.select_font("Helvetica")
    #pdf.select_font("Arial")
  
    i = 1
    @places = Place.find(params[:place_ids])
    for place in @places
      if params[:surat_iklan_content][:format_surat].to_i == 3
        #pdf.image "/aplikasi/www/instun/public/images/header800.jpg", :justification => :center
        pdf.add_image_from_file(header_image, 0, 730, 600, nil)
      end
      pdf.text "", :font_size => @font_size, :justification => :left
	
      @rujukan_kami = params[:rujukan_kami]
      @tarikh_surat_day = params[:tarikh_surat_day]
      @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
      @tarikh_surat_month = $MONTH_NAMES[params[:tarikh_surat_month].to_i - 1]
      @tarikh_surat_year = params[:tarikh_surat_year]
      @tarikh = "#{@tarikh_surat_day} #{@tarikh_surat_month} #{@tarikh_surat_year}"
      @perkara = params[:surat_iklan_content][:perkara]
      @perenggan1 = params[:surat_iklan_content][:perenggan1]
      @perenggan2 = params[:surat_iklan_content][:perenggan2]
      @perenggan3 = params[:surat_iklan_content][:perenggan3]
      @perenggan4 = params[:surat_iklan_content][:perenggan4]
      @perenggan5 = params[:surat_iklan_content][:perenggan5]
      @tempoh = params[:surat_iklan_content][:tempoh]
 
      addr1 = place.address1.split(" ").map! {|e| e}.join(" ") if ( (place.address1 != "") && place.address1 )
      addr2 = place.address2.split(" ").map! {|e| e}.join(" ") if ( (place.address2 != "") && place.address2 )
      addr3 = place.address3.split(" ").map! {|e| e}.join(" ") if ( (place.address3 != "") && place.address3 )
      addr4 = place.address4.split(" ").map! {|e| e}.join(" ") if ( (place.address4 != "") && place.address4 )
	
      addr1 = "(SILA KEMASKINI ALAMAT)" if place.address1 == ""
      addr2 = "(SILA KEMASKINI ALAMAT)" if place.address1 == ""
      addr3 = "(SILA KEMASKINI ALAMAT)" if place.address1 == ""
      addr4 = "(SILA KEMASKINI ALAMAT)" if place.address1 == ""
      state = nof{place.state.description}
      if state != nil
        state = place.state.description.split(" ").map! {|e| e.capitalize}.join(" ")
      end

      addr_arr = Array.new
      addr_arr.push(place.name) if place.name != ""
      addr_arr.push(addr1) if place.address1 != ""
      addr_arr.push(addr2) if place.address2 != ""
      addr_arr.push(addr3) if place.address3 != ""
      addr_arr.push(addr4) if place.address4 != ""
      #addr_arr.push(nof{state.upcase}) if place.state != ""
      company_addr = addr_arr.join("\n")
      company_addr = company_addr.tr_s(',' , ',')

      alamat = "#{company_addr}"

      salinan_kepada = params[:salinan_kepada]

      #first_paragraph = params[:first_paragraph]
      #second_paragraph = params[:second_paragraph]
      #third_paragraph = params[:third_paragraph]
      #fifth_paragraph = params[:fifth_paragraph]

      @rujukan_font_size = 10;
      if params[:surat_iklan_content][:format_surat].to_i == 3
        pdf.y = @my_margin -120
      else
        pdf.y = @my_margin -50
      end
      pdf.add_text(345, pdf.y, "Ruj. Tuan", @rujukan_font_size)
      pdf.add_text(395, pdf.y, ": ", @rujukan_font_size)
      pdf.text "\n", :font_size => @rujukan_font_size
      pdf.add_text(345, pdf.y, "Ruj. Kami", @rujukan_font_size)
      pdf.add_text(395, pdf.y, ":", @rujukan_font_size)
      pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @rujukan_font_size)
      pdf.text "\n", :font_size => @rujukan_font_size
      pdf.add_text(345, pdf.y, "Tarikh", @rujukan_font_size)
      pdf.add_text(395, pdf.y, ":", @rujukan_font_size)
      pdf.add_text(405, pdf.y, "#{@tarikh}", @rujukan_font_size)

      pdf.text "\n\n", :font_size => @font_size, :justification => :left
      pdf.text "#{nof{place.head_title}}", :font_size => @font_size, :justification => :left
      pdf.text "#{alamat}", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :left

      pdf.text "\n\n\n", :font_size => @font_size, :justification => :center
      pdf.text "Tuan,\n\n", :font_size => @font_size, :justification => :left
      @per_lines = @perkara.split("\n")
      for per_line in @per_lines
        pdf.text "<b>#{per_line} </b>", :font_size => @rujukan_font_size, :justification => :left
      end
      pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full, :right => 10
      pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full, :right => 10
      pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full, :right => 10
      pdf.text "\n", :font_size => @font_size, :justification => :full
      @per_lines2 = @perenggan4.split("\n")
      for per_line2 in @per_lines2
        pdf.text "#{per_line2} ", :font_size => @font_size, :justification => :full, :right => 10
      end
      pdf.text "\n", :font_size => @font_size, :justification => :full


      pdf.new_page
      pdf.y = @my_margin

      pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full, :right => 10

      pdf.text "\nSekian, terima kasih\n\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>`MENDAHULUI CABARAN`</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>`MS ISO 9001:2008 - PENGURUSAN LATIHAN`</b>\n\n", :font_size => @font_size, :justification => :left
      pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left

      if params[:surat_iklan_content][:is_cetakan_komputer].to_i == 0

        if RUBY_PLATFORM == "i386-mswin32"
          @signature_file = "public/signatures/#{params[:signature_file]}"
        else
          @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
        end
		
        if params[:signature_file] and params[:signature_file] != ""
          pdf.image @signature_file, :resize => 0.5
        else
          pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left
        end
      end

      if @tandatangan_nama != "SR HJ. ANUAR BIN HJ. SULAIMAN"
        pdf.text "\n<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
      end
      pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
      pdf.text "Institut Tanah & Ukur Negara(INSTUN)", :font_size => @font_size, :justification => :left
      pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left

      pdf.text "\ns.k", :font_size => @font_size, :justification => :left
      sk_lines = salinan_kepada.split("\n")
      for sk_line in sk_lines
        pdf.add_text(100, pdf.y, "#{sk_line}", @font_size)
        pdf.text "\n", :font_size => @font_size
      end
      @nota_font_size = 9
      current_y = pdf.y
      pdf.y = pdf.absolute_bottom_margin - 20
      pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:surat_iklan_content][:is_cetakan_komputer].to_i==1

      pdf.new_page if i < @places.size
      i = i+1
      pdf.y = @my_margin


    end # @places loop

    require 'pdf/simpletable'
    pdf.y = current_y
    #schedules = CourseImplementation.find(params[:schedule_ids])
    schedule = CourseImplementation.find(params[:surat_iklan_content][:course_implementation_id])
    i = 1
    if schedule
      #for schedule in schedules
      pdf.new_page
      pdf.y = pdf.absolute_top_margin - 20
      #pdf.text "#{schedule.course.name.upcase}", :font_size => @font_size, :justification => :left

      tarikh = "#{schedule.date_plan_start.to_formatted_s(:my_format_4)} hingga #{schedule.date_plan_end.to_formatted_s(:my_format_4)}"
      tempoh = (schedule.date_plan_end-schedule.date_plan_start) + 1

      arr = Array.new
      for methodology in schedule.course.methodologies
        arr.push(methodology.description)
      end
      methodologies = arr.join(', ')

      tarikh_tutup = ""
      tarikh_tutup = schedule.last_date.to_formatted_s(:my_format_3) if schedule.last_date

      if i == 1
        pdf.add_text(490, pdf.y, "Lampiran A", @rujukan_font_size)
        pdf.text "\n", :font_size => @font_size
      end

      table = PDF::SimpleTable.new

      table.data = [
        { "key" => "Kod Kursus", "value" => "#{schedule.code}" },
        { "key" => "Modul", "value" => "#{schedule.course.course_field.description} : #{schedule.course.name}" },
        { "key" => "Kelayakan Peserta", "value" => "#{schedule.course.target_group}" },
        { "key" => "Tarikh", "value" => "#{tarikh}" },
        { "key" => "Tempoh", "value" => "#{tempoh} hari" },
        { "key" => "Objektif", "value" => "#{schedule.course.objective}" },
        { "key" => "Kandungan", "value" => "#{schedule.course.content}" },
        { "key" => "Metodologi", "value" => "#{methodologies}" },
        { "key" => "Bilangan Peserta", "value" => "#{schedule.capacity} orang" },
        { "key" => "Tarikh Tutup", "value" => "#{tarikh_tutup}" }
      ]


      table.column_order = [ "key", "value" ]
      table.position = :center
      #table.orientation = :center
      #table.title = "Lampiran A" if i == 0
      table.shade_rows = :true
      table.show_headings = false
      table.show_lines = :inner
      table.width = 500

      table.render_on(pdf)
      #i = i + 1
    end

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end

  end

  #################################################################################
  private
  def gen_pdf_all_format_2 (file)
    @font_size = 12
    header_image = "/aplikasi/www/instun/public/images/header800.jpg"
    pdf = PDF::Writer.new(:paper=>"A4")
    if params[:surat_iklan_content][:format_surat].to_i == 4
      pdf.margins_pt(0, 50, 36, 50)
  	else
      pdf.margins_pt(36, 50, 36, 50)
  	end
    #pdf.select_font("Arial")
    pdf.select_font("Helvetica")
    @my_margin = pdf.absolute_top_margin - 30
  
    ###set dulu isi surat
    if params[:surat_iklan_content][:format_surat].to_i == 4
      pdf.add_image_from_file(header_image, 0, 730, 600, nil)
      #pdf.image "/aplikasi/www/instun/public/images/header800.jpg", :justification => :center
    end
    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = $MONTH_NAMES[params[:tarikh_surat_month].to_i - 1]
    @tarikh_surat_year = params[:tarikh_surat_year]
    @tarikh = "#{@tarikh_surat_day} #{@tarikh_surat_month} #{@tarikh_surat_year}"
    @perkara = params[:surat_iklan_content][:perkara]
    @perenggan1 = params[:surat_iklan_content][:perenggan1]
    @perenggan2 = params[:surat_iklan_content][:perenggan2]
    @perenggan3 = params[:surat_iklan_content][:perenggan3]
    @perenggan4 = params[:surat_iklan_content][:perenggan4]
    @perenggan5 = params[:surat_iklan_content][:perenggan5]
    @tempoh = params[:surat_iklan_content][:tempoh]
    salinan_kepada = params[:salinan_kepada]


    #####start writing letter!####################################################
    if params[:surat_iklan_content][:format_surat].to_i == 4
      pdf.y = @my_margin -120
    else
      pdf.y = @my_margin -50
    end
    
    pdf.text "", :font_size => @font_size, :justification => :left
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    
    @rujukan_font_size = 10
    @rujukan_font_size2 = 13
    #pdf.y = @my_margin -50
	  pdf.add_text(345, pdf.y, "Ruj. Tuan", @rujukan_font_size)
    pdf.add_text(395, pdf.y, ": ", @rujukan_font_size)
    pdf.text "\n", :font_size => @rujukan_font_size
    pdf.add_text(345, pdf.y, "Ruj. Kami", @rujukan_font_size)
    pdf.add_text(395, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @rujukan_font_size)
    pdf.text "\n", :font_size => @rujukan_font_size
    pdf.add_text(345, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(395, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(405, pdf.y, "#{@tarikh}", @rujukan_font_size)
    
    pdf.text "\n<b>SEPERTI SENARAI EDARAN </b>", :font_size => @rujukan_font_size2, :justification => :left
    pdf.text "\n\n", :font_size => @font_size, :justification => :center
    pdf.text "Tuan,\n\n", :font_size => @font_size, :justification => :left
    @per_lines = @perkara.split("\n")
    for per_line in @per_lines
      pdf.text "<b>#{per_line} </b>", :font_size => @rujukan_font_size, :justification => :left
    end
    pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full, :right => 10
    pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full, :right => 10
    pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full, :right => 10
    pdf.text "\n", :font_size => @font_size, :justification => :center
    @per_lines2 = @perenggan4.split("\n")
  	for per_line2 in @per_lines2
      pdf.text "#{per_line2} ", :font_size => @font_size, :justification => :full
  	end
    pdf.text "\n", :font_size => @font_size, :justification => :center

    pdf.new_page
    pdf.y = @my_margin

    pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full, :right => 10

    pdf.text "\nSekian, terima kasih\n\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>'BERKHIDMAT UNTUK NEGARA'</b>\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>'MENDAHULUI CABARAN'</b>\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>'MS ISO 9001:2008 - PENGURUSAN LATIHAN'</b>\n\n", :font_size => @font_size, :justification => :left
    pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left

    if params[:surat_iklan_content][:is_cetakan_komputer].to_i == 0

      if RUBY_PLATFORM == "i386-mswin32"
        @signature_file = "public/signatures/#{params[:signature_file]}"
      else
        @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
      end
		
      if params[:signature_file] and params[:signature_file] != ""
        pdf.image @signature_file, :resize => 0.5
      else
        pdf.text " \n \n \n \n", :font_size => @font_size, :justification => :left
      end
    end
    if @tandatangan_nama != "SR HJ. ANUAR BIN HJ. SULAIMAN"
      pdf.text "\n<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
    end
    pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
    pdf.text "Institut Tanah & Ukur Negara(INSTUN)", :font_size => @font_size, :justification => :left
    pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left
    pdf.text "\ns.k", :font_size => @font_size, :justification => :left
	
    sk_lines = salinan_kepada.split("\n")
    for sk_line in sk_lines
      pdf.add_text(100, pdf.y, "#{sk_line}", @font_size)
      pdf.text "\n", :font_size => @font_size
    end

    pdf.new_page
    pdf.y = pdf.absolute_top_margin - 20
    pdf.text "\n<b>SENARAI EDARAN</b>\n", :font_size => @font_size, :justification => :left
    i = 1
    @places = Place.find(params[:place_ids])
    for place in @places
	    pdf.text "", :font_size => @font_size, :justification => :left
 
      addr1 = place.address1.split(" ").map! {|e| e}.join(" ") if ( (place.address1 != "") && place.address1 )
      addr2 = place.address2.split(" ").map! {|e| e}.join(" ") if ( (place.address2 != "") && place.address2 )
      addr3 = place.address3.split(" ").map! {|e| e}.join(" ") if ( (place.address3 != "") && place.address3 )
      addr4 = place.address4.split(" ").map! {|e| e}.join(" ") if ( (place.address4 != "") && place.address4 )
      if place.state
        state = place.state.description.split(" ").map! {|e| e.capitalize}.join(" ")
      else
        state = " "
      end

      addr_arr = Array.new
      addr_arr.push(place.name) if place.name != ""
      addr_arr.push(addr1) if place.address1 != ""
      addr_arr.push(addr2) if place.address2 != ""
      addr_arr.push(addr3) if place.address3 != ""
      addr_arr.push(addr4) if place.address4 != ""
      #addr_arr.push(state.upcase) if place.state != ""
      company_addr = addr_arr.join("\n")
      company_addr = company_addr.tr_s(',' , ',')
	    alamat = "#{company_addr}"

      pdf.text "\n\n#{nof{place.head_title}}", :font_size => @font_size, :justification => :left
      pdf.text "#{alamat}", :font_size => @font_size, :justification => :left

    end # @places loop
    @nota_font_size = 9
    current_y = pdf.y
    pdf.y = pdf.absolute_bottom_margin - 20
    pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:surat_iklan_content][:is_cetakan_komputer].to_i==1


    require 'pdf/simpletable'
    pdf.y = current_y
    schedule = CourseImplementation.find(params[:surat_iklan_content][:course_implementation_id])
    #schedules = CourseImplementation.find(params[:schedule_ids])
    i = 1
    #for schedule in schedules
    if schedule
      pdf.new_page
      pdf.y = pdf.absolute_top_margin - 20

      if i == 1
        pdf.add_text(490, pdf.y, "Lampiran A", @rujukan_font_size)
        pdf.text "\n", :font_size => @font_size
      end

      tarikh = "#{schedule.date_plan_start.to_formatted_s(:my_format_4)} hingga #{schedule.date_plan_end.to_formatted_s(:my_format_4)}"
      tempoh = (schedule.date_plan_end-schedule.date_plan_start) + 1

      arr = Array.new
      for methodology in schedule.course.methodologies
        arr.push(methodology.description)
      end
      methodologies = arr.join(', ')

      tarikh_tutup = ""
      tarikh_tutup = schedule.last_date.to_formatted_s(:my_format_3) if schedule.last_date

      table = PDF::SimpleTable.new

      table.data = [
        { "key" => "Kod Kursus", "value" => "#{schedule.code}" },
        { "key" => "Modul", "value" => "#{schedule.course.course_field.description} : #{schedule.course.name}" },
        { "key" => "Kelayakan Peserta", "value" => "#{schedule.course.target_group}" },
        { "key" => "Tarikh", "value" => "#{tarikh}" },
        { "key" => "Tempoh", "value" => "#{tempoh} hari" },
        { "key" => "Objektif", "value" => "#{schedule.course.objective}" },
        { "key" => "Kandungan", "value" => "#{schedule.course.content}" },
        { "key" => "Metodologi", "value" => "#{methodologies}" },
        { "key" => "Bilangan Peserta", "value" => "#{schedule.capacity} orang" },
        { "key" => "Tarikh Tutup", "value" => "#{tarikh_tutup}" }
      ]


      table.column_order = [ "key", "value" ]
      table.position = :center
      #table.orientation = :center
      #table.title = "   Lampiran A" if i == 0
      table.shade_rows = :true
      table.show_headings = false
      table.show_lines = :inner
      table.width = 500
      table.render_on(pdf)
    
      #i = i + 1
    end

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end

  end

  #################################################################################

  
  
  private
  def gen_pdf (file)
    @font_size = 11

    pdf = PDF::Writer.new(:paper=>"A4")
    pdf.margins_pt(36, 70, 36, 70) # 36 54 72 90
    pdf.select_font("Times-Roman")
    #pdf.select_font("Helvetica")
  
    #pdf.image "public/images/header_install.png", :justification => :center
    #pdf.add_image_from_file("public/images/logo.jpg",100,660)
    pdf.text "", :font_size => @font_size, :justification => :left
	
    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_month = $MONTH_NAMES[params[:tarikh_surat_month].to_i - 1]
    @tarikh_surat_year = params[:tarikh_surat_year]
    @tarikh = "#{@tarikh_surat_day} #{@tarikh_surat_month} #{@tarikh_surat_year}"
    @perkara = params[:perkara]
    @perenggan4 = params[:perenggan4]
    @tempoh = params[:tempoh]

    alamat = "\n\n\n
No 59, Jalan Bunga Kemboja,
Bandar Sri Damansara,
50900 Kuala Lumpur."

    alamat_instun = "
Pengarah,
Institut Tanah dan Ukur Negara(INSTUN),
Kementerian Sumber Asli dan Alam Sekitar(NRE),
Behrang,
35950 Tanjung Malim,
Perak Darul Ridzuan."

    salinan_kepada = "Ketua Setiausaha
Kementerian Sumber Asli dan Alam Sekitar(NRE),
Aras 17, Blok Menara 4G3, Precint 14,
Pusat Pentadbiran Kerajaan Persekutuan,
62574 Putrajaya.

Fail FLoat"

    first_paragraph = "Adalah saya dengan hormatnya merujuk kepada perkara di atas dan memaklumkan bahawa institut ini menjemput pihak tuan mengemukakan senarai calon bagi kursus-kursus sebagaimana di <b>Lampiran 'A'</b> untuk sepanjang bulan <b>#{@tempoh}</b>."

    second_paragraph = "2.     Sehubungan dengan itu, kerjasama tuan adalah dipohon untuk memaklumkan perkara di atas kepada semua Seksyen/Bahagian/Negeri yang berkaitan dengan pihak tuan."

    third_paragraph = "3.     Untuk makluman tuan, pihak institut akan menyediakan kemudahan tempat penginapan serta makan/minum di sepanjang kursus. Peserta kursus hanya boleh membuat tuntutan yuran pendaftaran kursus dan elaun perjalanan sahaja kepada jabatan masing-masing mengikut kelayakan masing-masing."

    fourth_paragraph = "4.     Bersama-sama ini disertakan <b>Borang Permohonan Kursus</b> untuk disempurnakan oleh calon. Semua pencalonan hendaklah dikemukakan melalui <b>Faks</b> di talian <b>05-4542843</b> atau <b>melalui pos sebelum atau pada <c:uline> 15 haribulan bagi setiap bulan</c:uline></b> kepada :"

    fifth_paragraph = "5.     Sekiranya pihak tuan mempunyai sebarang pertanyaan berkenaan kursus-kursus ini, sila hubungi Unit Pengurusan Latihan ICT di talian 05-4542825 sambungan 3342 atau 3346 atau di laman web rasmi INSTUN http://www.instun.gov.my/indeks.htm"

    pdf.text "", :font_size => @font_size, :justification => :left
    pdf.text "#{alamat}", :font_size => @font_size, :justification => :left
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
         
    pdf.add_text(345, pdf.y, "Ruj. Tuan", @font_size)
    pdf.add_text(395, pdf.y, ": ", @font_size)
    pdf.text "\n", :font_size => @font_size
    pdf.add_text(345, pdf.y, "Ruj. Kami", @font_size)
    pdf.add_text(395, pdf.y, ":", @font_size)
    pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @font_size)
    pdf.text "\n", :font_size => @font_size
    pdf.add_text(345, pdf.y, "Tarikh", @font_size)
    pdf.add_text(395, pdf.y, ":", @font_size)
    pdf.add_text(405, pdf.y, "#{@tarikh}", @font_size)

    pdf.text "\n\n\n", :font_size => @font_size, :justification => :center
    pdf.text "Tuan,\n\n", :font_size => @font_size, :justification => :left
    @per_lines = @perkara.split("\n")
    for per_line in @per_lines
      pdf.text "<b><c:uline>#{per_line} </c:uline></b>", :font_size => @font_size, :justification => :left
    end
    #pdf.text "<c:uline><b>#{@perkara}</b></c:uline>\n", :font_size => @font_size, :justification => :left
    pdf.text "\n#{first_paragraph}", :font_size => @font_size, :justification => :full
    pdf.text "\n#{second_paragraph}", :font_size => @font_size, :justification => :full
    pdf.text "\n#{third_paragraph}", :font_size => @font_size, :justification => :full
    #pdf.text "\n#{fourth_paragraph}", :font_size => @font_size, :justification => :full
    pdf.text "\n", :font_size => @font_size, :justification => :center
    @per_lines2 = @perenggan4.split("\n")
  	for per_line2 in @per_lines2
      pdf.text "#{per_line2} ", :font_size => @font_size, :justification => :left
  	end
    pdf.text "\n", :font_size => @font_size, :justification => :center
    #pdf.text "<b>#{alamat_instun}</b>\n\n", :font_size => @font_size, :justification => :left

    #addr_lines = alamat_instun.split("\n")
    #for addr_line in addr_lines
    #    pdf.add_text(100, pdf.y, "<b>#{addr_line}</b>", @font_size)
    #    pdf.text "\n", :font_size => @font_size
    #end

    pdf.new_page
    pdf.y = pdf.absolute_top_margin - 20

    pdf.text "\n#{fifth_paragraph}", :font_size => @font_size, :justification => :full

    pdf.text "\nSekian, terima kasih\n\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n\n", :font_size => @font_size, :justification => :left
    pdf.text "Saya yang menurut perintah,\n\n\n\n\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>(DATO' HAJI MOHD SHAFIE BIN ARIFIN)</b>", :font_size => @font_size, :justification => :left
    pdf.text "Pengarah,\n", :font_size => @font_size, :justification => :left
    pdf.text "Institut Tanah & Ukur Negara(INSTUN)", :font_size => @font_size, :justification => :left
    pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left

    #pdf.text "\n#{salinan_kepada}", :font_size => @font_size, :justification => :full
    pdf.text "\ns.k", :font_size => @font_size, :justification => :left
    sk_lines = salinan_kepada.split("\n")
    for sk_line in sk_lines
      pdf.add_text(100, pdf.y, "#{sk_line}", @font_size)
      pdf.text "\n", :font_size => @font_size
    end

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end

  end




  #########################################################333
  private
  def gen_show_pdf (file)

    pdf = PDF::Writer.new
    pdf.select_font("Times-Roman")
    #pdf.select_font("Helvetica")
  
	
    a = "show #{@course.name}"
  
    #pdf.text @pattern.logo.name, :font_size => 10, :justification => :left
    pdf.text "\n\n", :font_size => 10, :justification => :left
    pdf.text "Adalah diperakukan bahawa #{a}", :font_size => 10, :justification => :center    
    pdf.save_as("public/surat/" + file)

  end

end

#@where_sql += " AND (coordinator1=#{params[:coordinator]} OR coordinator2=#{params[:coordinator]})"
	
