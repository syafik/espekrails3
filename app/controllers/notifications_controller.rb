# -*- encoding : utf-8 -*-
class NotificationsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def listp
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 365)
    yesterday = today + (60 * 60 * 24 * 365)
    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    @day_past, @month_past, @year_past = yesterday.day, yesterday.month, yesterday.year
    @report_date_from = "#{@day_next}/#{@month_next}/#{@year_next}" if !params[:report1]
    @report_date_to = "#{@day_past}/#{@month_past}/#{@year_past}" if !params[:report2]

    begin
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

      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
      date_end = "#{@month_past}/#{@day_past}/#{@year_past}" if !params[:report2]

      @notifications = Notification.find(:all, :conditions=>"(profile_id = '#{session[:user].profile.id}') AND ((approved_on is not null and status ='1') or (approved_on is null and status ='0')) AND ((date_plan_start BETWEEN '#{date_start}' AND '#{date_end}') OR (date_plan_end BETWEEN '#{date_start}' AND '#{date_end}') OR ('#{date_start}' BETWEEN date_plan_start AND date_plan_end) OR ('#{date_end}' BETWEEN date_plan_start AND date_plan_end))")
      #rescue
      #redirect_to :controller => 'notifications',:action => 'listp'
    end
  end

  def list
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 30)
    yesterday = today + (60 * 60 * 24 * 30)
    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    @day_past, @month_past, @year_past = yesterday.day, yesterday.month, yesterday.year
    @report_date_from = "#{@day_next}/#{@month_next}/#{@year_next}" if !params[:report1]
    @report_date_to = "#{@day_past}/#{@month_past}/#{@year_past}" if !params[:report2]

    begin
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

      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
      date_end = "#{@month_past}/#{@day_past}/#{@year_past}" if !params[:report2]
    
      @notifications = Notification.find(:all, :conditions=>"(date_plan_start BETWEEN '#{date_start}' AND '#{date_end}') OR (date_plan_end BETWEEN '#{date_start}' AND '#{date_end}') OR ('#{date_start}' BETWEEN date_plan_start AND date_plan_end) OR ('#{date_end}' BETWEEN date_plan_start AND date_plan_end)")
    rescue
      redirect_to :controller => 'notifications',:action => 'list'
    end
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def detail
    @notification = Notification.find(params[:id])
    @course_implementation = CourseImplementation.find(@notification.course_implementation_id)
    f = "student_status_id"
    s = Array.new
    s.push("#{f} = 4")
    s.push("#{f} = 5")
    s.push("#{f} = 2")
    t = s.join(" OR ")
    @students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (#{t})")
  end

  def report
    @facilities = Facility.find(:all, :conditions=>"facility_category_id=2", :order=>"name")
  end


  def new
    @course_implementation = CourseImplementation.find(params[:id])
    @check = Notification.find_by_course_implementation_id(@course_implementation.id)
    #@course_locations = CourseLocation.find(:all, :order=>"id")
    if @check
      @facilities = Facility.find(:all, :conditions=>"facility_category_id=2", :order=>"name")
    else
      datefrom = @course_implementation.date_start
      dateto = @course_implementation.date_end
      @facilities = Facility.find_by_sql("SELECT * FROM facilities WHERE facility_category_id = '2' AND id NOT IN (SELECT facility_id FROM facility_reservations WHERE (date_from BETWEEN '#{datefrom}' AND '#{dateto}') OR (date_to BETWEEN '#{datefrom}' AND '#{dateto}')) ORDER BY code")
    end
    @notification = Notification.new
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    @male = CourseApplication.find_by_sql("select * from course_applications INNER JOIN profiles ON profiles.id = course_applications.profile_id WHERE (student_status_id=4 or student_status_id=2 or student_status_id=5) AND course_implementation_id ='#{@course_implementation.id}'")
    #female = CourseApplication.find_by_sql("select * from course_applications INNER JOIN profiles ON profiles.id = course_applications.profile_id WHERE student_status_id=4 AND gender_id=2 AND course_implementation_id ='#{@course_implementation.id}'")  
    #@total = male + female
  end

  def create
    @course_implementation = CourseImplementation.find(params[:notification][:course_implementation_id])
    ds = @course_implementation.date_start
    de = @course_implementation.date_end
    howlong = (de-ds).to_i+1
    @options = Array.new;
    @days = Array.new
    howlong.times do |i|
  		b = ds+i
  		c = b#dmy(b,"-","/");
  		@options.push([c,ds+i]);
    end
    @days = @options;

  	if params[:hari] != nil
  		@days.each { |day|
  			#sql = "SELECT * FROM facility_reservations WHERE course_implementation_id=#{@course_implementation.id}"
  			#exist = FacilityReservation.find_by_sql(sql)
  			#if exist.size == 1
  			#	exist[0].destroy
  			#end
  			@s = FacilityReservation.new(params[:hari][day[1].to_s])
  			@s.course_implementation_id = @course_implementation.id
  			@s.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
  			@s.profile_id = params[:notification][:profile_id]
  			@s.date_from = day[1].to_s
  			@s.date_to = day[1].to_s
  			@s.save	
  		}
  	end
    @notification = Notification.new(params[:notification])
    @notification.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
    if @notification.save
      flash[:notice] = 'Makluman Kepada Seksyen Keselamatan Telah Dihantar'
      EspekMailer.security_notify(@notification.id).deliver
      if params[:ispopup] and params[:ispopup] == "1"
        redirect_to :controller => 'notifications', :action => 'show_popup', :id => @notification
  	  else
  	  	redirect_to :controller => 'course_applications', :action => 'select_course'
  	  end
    else
      render :action => 'new'
    end
  end

  def edit
    @notification = Notification.find_by_id(params[:id])
    @course_implementation = CourseImplementation.find(@notification.course_implementation_id)
    @facility_reservations = FacilityReservation.find(:all,:conditions => ["course_implementation_id = ?",@course_implementation.id],
      :order => 'date_from asc')

   
     
     
    #@course_locations = CourseLocation.find(:all, :order=>"id")
    #@check = @notification
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
    if @notification.update_attributes(params[:notification])
      flash[:notice] = 'Makluman Telah Berjaya Dikemaskini'
      if params[:ispopup] and params[:ispopup] == "1"
        redirect_to :action => 'show_popup', :id => @notification
      else
        redirect_to :controller => 'course_applications', :action => 'select_course'
      end
    else
      render :action => 'new'
    end   
  end

  def approve
    @notification = Notification.find_by_id(params[:id])
    logger.debug @notification
    @notification.approved_on = params[:month_approve]+"/"+params[:day_approve]+"/"+params[:year_approve]
    if @notification.update_attributes(params[:notification])
      flash[:notice] = 'Makluman Pelaksanaan Kursus Telah Disahkan'
      EspekMailer.security_approve(@notification.id).deliver
      if params[:ispopup] and params[:ispopup] == "1"
        redirect_to :action => 'show_popup', :id => @notification
      else
        redirect_to :action => 'list'
      end
    else
      render :action => 'new'
    end
  end
    
  def destroy
    Notification.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def urushubung
    @security_contacts = SecurityContact.find(:all, :order => 'id desc')
    @security_contact = SecurityContact.find(params[:id]) unless params[:id].nil?
    if @security_contact.nil?
      @security_contact = SecurityContact.new(params[:security_contact])
    end
  end
  
  def create_security_contact
    @security_contacts = SecurityContact.find(:all, :order => 'id desc')
    @security_contact = SecurityContact.find(params[:id]) unless params[:id].nil?
    if @security_contact.nil?
      @security_contact = SecurityContact.new(params[:security_contact])
  		if @security_contact.save
        redirect_to(:controller => 'notifications', :action => 'urushubung')
  		else
        render(:controller => 'notifications', :action => 'urushubung')
  		end
    else
      if @security_contact.update_attributes(params[:security_contact])
        redirect_to(:controller => 'notifications', :action => 'urushubung')
  		else
        render(:controller => 'notifications', :action => 'urushubung')
  		end
    end
  end
  
  def delete_security_contact
    @security_contact = SecurityContact.find(params[:id])
    @security_contact.destroy
    redirect_to :back
  end
  
  def senaraibilik
    @facilities = Facility.find(:all, :conditions=>"facility_category_id=2", :order=>"name")
  end
  
  def jadual_bilik_kuliah
    @facility = Facility.find(params[:id])
    @facility_reservations = FacilityReservation.find(:all,
      :conditions => ["facility_id = ?",@facility.id])
  end
  
end










