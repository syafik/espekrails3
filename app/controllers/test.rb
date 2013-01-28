# -*- encoding : utf-8 -*-
class ReportController < ApplicationController
  layout "standard-layout"

	def initialize

	end

	def index
		list
	end


  def list_comp_location
		@cond = Array.new()
		@cond.push("state_id="	+  params[:state_id])  if params[:state_id].to_i > 0

		@a = @cond.join(" AND ")

		#if @a != ""
		#@organizations = Organization.find(:all, :conditions=> @a)
		#else
		#  #@organizations = Organization.find(:all)
		#  @organizations = []
		#end
	end

	def statistik
      @course_departments = CourseDepartment.find(:all, :order=>"code")
      today = Time.new
      @day, @month, @year = today.day, today.month, today.year
      tomorrow = today - (60 * 60 * 24 * 14)
      @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    end


    def kemajuan
	@course_departments = CourseDepartment.find(:all, :order=>"code")
	today = Time.new
	@day, @month, @year = today.day, today.month, today.year
	tomorrow = today - (60 * 60 * 24 * 14)
	@day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year

    end

	def kursus_online
      @course_departments = CourseDepartment.find(:all, :order=>"id")
      today = Time.new
      @day, @month, @year = today.day, today.month, today.year
      tomorrow = today - (60 * 60 * 24 * 14)
      @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year

      if params[:report1]
      tarikh1 = params[:report1].to_s
      tarikhi = tarikh1.split('/')
      d = tarikhi[0]
      m = tarikhi[1]
      y = tarikhi[2]
      date_start = m+"/"+d+"/"+y
      end

      if params[:report2]
      tarikh2 = params[:report2].to_s
      tarikhii = tarikh2.split('/')
      d = tarikhii[0]
      m = tarikhii[1]
      y = tarikhii[2]
      date_end = m+"/"+d+"/"+y
      end

      #date_start = params[:report1]
      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
      #date_end = params[:report2]
      date_end = "#{@month}/#{@day}/#{@year}" if !params[:report2]
      begin
	if !params[:course_department_id]
	@students = CourseApplication.find_by_sql("select * from vw_detailed_peserta WHERE date_apply >= '#{date_start}' AND date_apply <= '#{date_end}' order by date_apply ASC")
	else
	@students = CourseApplication.find_by_sql("select * from vw_detailed_peserta WHERE course_department_id = '#{params[:course_department_id]}' AND date_apply >= '#{date_start}' AND date_apply <= '#{date_end}' order by date_apply ASC")
	end
      rescue
	redirect_to :action => 'kursus_online'
      end

	end

	def kursus_semasa
	  @course_departments = CourseDepartment.find(:all, :order=>"id")
      today = Time.new
      @day, @month, @year = today.day, today.month, today.year
      tomorrow = today - (60 * 60 * 24 * 14)
      @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year

      if params[:report1]
      tarikh1 = params[:report1].to_s
      tarikhi = tarikh1.split('/')
      d = tarikhi[0]
      m = tarikhi[1]
      y = tarikhi[2]
      date_start = m+"/"+d+"/"+y
	  @report_date_from = tarikh1
      end

      if params[:report2]
      tarikh2 = params[:report2].to_s
      tarikhii = tarikh2.split('/')
      d = tarikhii[0]
      m = tarikhii[1]
      y = tarikhii[2]
      date_end = m+"/"+d+"/"+y
	  @report_date_to = tarikh2
      end

      #date_start = params[:report1]
      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
      #date_end = params[:report2]
      date_end = "#{@month}/#{@day}/#{@year}" if !params[:report2]
      begin
	if !params[:course_department_id]
	#@students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE course_status_id ='1' AND date_plan_start BETWEEN '#{date_start}' AND '#{date_end}' OR date_plan_end BETWEEN '#{date_start}' AND '#{date_end}' order by date_plan_start ASC")
	@students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE course_status_id ='1' AND ('#{date_start}' BETWEEN date_plan_start AND date_plan_end) OR ('#{date_end}' BETWEEN date_plan_start AND date_plan_end) order by date_plan_start ASC")
	else
	#@students = CourseImplementation.find_by_sql("select * from  vw_detailed_courses WHERE course_status_id ='1' AND course_department_id = '#{params[:course_department_id]}' AND date_plan_start BETWEEN '#{date_start}' AND '#{date_end}' OR date_plan_end BETWEEN '#{date_start}' AND '#{date_end}' order by date_plan_start ASC")
	@students = CourseImplementation.find_by_sql("select * from  vw_detailed_courses WHERE course_status_id ='1' AND course_department_id = '#{params[:course_department_id]}' AND ( ('#{date_start}' >= date_plan_start AND '#{date_start}' <= date_plan_end) OR ('#{date_end}' >= date_plan_start AND '#{date_end}' <= date_plan_end) ) order by date_plan_start ASC")
	end
      rescue
	redirect_to :action => 'kursus_semasa'
      end

	end

end
