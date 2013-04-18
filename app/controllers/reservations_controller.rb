# -*- encoding : utf-8 -*-
class ReservationsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def listp
    #@reservation_pages, @reservations = paginate :reservations, :per_page => 50
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 365)
    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    yesterday = today + (60 * 60 * 24 * 365)
    @day_past, @month_past, @year_past = yesterday.day, yesterday.month, yesterday.year
      
    @report_date_from = "#{@day_next}/#{@month_next}/#{@year_next}" if !params[:report1]
    @report_date_to = "#{@day_past}/#{@month_past}/#{@year_past}" if !params[:report2]

    begin
      if params[:report1]
        tarikh1 = params[:report1][0].to_s
        tarikhi = tarikh1.split('/')
        d = tarikhi[0]
        m = tarikhi[1]
        y = tarikhi[2]
        date_start = m+"/"+d+"/"+y
#        date_start = tarikh1
        @report_date_from = tarikh1
      end

      if params[:report2]
        tarikh2 = params[:report2][0].to_s
        tarikhii = tarikh2.split('/')
        d = tarikhii[0]
        m = tarikhii[1]
        y = tarikhii[2]
        date_end = m+"/"+d+"/"+y
#        date_end = tarikh2
        @report_date_to = tarikh2
      end

      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if params[:report1].blank?
      date_end = "#{@month}/#{@day}/#{@year}" if params[:report2].blank?
      
      @reservations = Reservation.find(:all,        
        :conditions=>"(date_plan_start BETWEEN '#{date_start}' AND '#{date_end}') OR (date_plan_end BETWEEN '#{date_start}' AND '#{date_end}') OR ('#{date_start}' BETWEEN date_plan_start AND date_plan_end) OR ('#{date_end}' BETWEEN date_plan_start AND date_plan_end)", :order => "updated_on desc")
          
    rescue Exception => s
      logger.debug "s==================="
      logger.debug s
      redirect_to :action => 'listp'
    end
  end

  def list
    #@reservation_pages, @reservations = paginate :reservations, :per_page => 50
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 100)
    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    yesterday = today + (60 * 60 * 24 * 100)
    @day_past, @month_past, @year_past = yesterday.day, yesterday.month, yesterday.year
      
    @report_date_from = "#{@day_next}/#{@month_next}/#{@year_next}" if !params[:report1]
    @report_date_to = "#{@day_past}/#{@month_past}/#{@year_past}" if !params[:report2]

    begin
      if params[:report1]
        tarikh1 = params[:report1].first.to_s
        tarikhi = tarikh1.split('/')
        d = tarikhi[0]
        m = tarikhi[1]
        y = tarikhi[2]
        date_start = m+"/"+d+"/"+y
        @report_date_from = tarikh1
      end

      if params[:report2]
        tarikh2 = params[:report2].first.to_s
        tarikhii = tarikh2.split('/')
        d = tarikhii[0]
        m = tarikhii[1]
        y = tarikhii[2]
        date_end = m+"/"+d+"/"+y
        @report_date_to = tarikh2
      end

      date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
      date_end = "#{@month}/#{@day}/#{@year}" if !params[:report2]
      
      @reservations = Reservation.find(:all, :conditions=>"(date_plan_start BETWEEN '#{date_start}' AND '#{date_end}') OR (date_plan_end BETWEEN '#{date_start}' AND '#{date_end}') OR ('#{date_start}' BETWEEN date_plan_start AND date_plan_end) OR ('#{date_end}' BETWEEN date_plan_start AND date_plan_end)")
	  
    rescue
      redirect_to :action => 'list'
    end
  end
  
  def detail
    @reservation = Reservation.find(params[:id])
    @course_implementation = CourseImplementation.find(@reservation.course_implementation_id)
    f = "student_status_id"
  	s = Array.new
  	s.push("#{f} = 4")
    s.push("#{f} = 5")
    s.push("#{f} = 8")
    t = s.join(" OR ")
    @students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (#{t})")
  end

  def show
    @reservation = Reservation.find(params[:id])
    #@course_implementation = CourseImplementation.find(@reservation.course_implementation_id)
    @course_implementation = @reservation.course_implementation
  end

  def show_popup
  	show
  end


  def edit_trainer_book_sah
    @reservation = Reservation.find(params[:id])
    @course_implementation = CourseImplementation.find(@reservation.course_implementation_id)
    @coordinators= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")
    @check = @course_implementation.reservation_trainers.first
  end
  
  def trainer_book_sah
  	@course_implementation = CourseImplementation.find(params[:id])
    for trainer in @course_implementation.reservation_trainers
      trainer.update_attributes(:status=>"1")
    end
    EspekMailer.domestik_sahkan_tempahan(@course_implementation.id).deliver
    flash[:notice] = 'Tempahan Asrama (Penceramah) Telah Berjaya Disahkan.'
    redirect_to :action => 'show_trainer_book', :id => @course_implementation.id
  end

  def show_trainer_book
    @course_implementation = CourseImplementation.find(params[:id])
    @reservation_trainer = @course_implementation.reservation_trainers.first
  end
    
  def trainer_book
    @course_implementation = CourseImplementation.find(params[:id])
    @cimp = @course_implementation
	
    if @course_implementation.reservation_trainers.size == 0
      @trainers = @course_implementation.trainers
		
      @year_check_in   = @cimp.check_in.to_formatted_s(:my_format_year)
      @month_check_in  = @cimp.check_in.to_formatted_s(:my_format_month)
      @day_check_in    = @cimp.check_in.to_formatted_s(:my_format_day)
      @hour_check_in   = @cimp.check_in.to_formatted_s(:my_format_hour)
      @minute_check_in = @cimp.check_in.to_formatted_s(:my_format_minute)
		
      @year_check_out   = @cimp.check_out.to_formatted_s(:my_format_year)
      @month_check_out  = @cimp.check_out.to_formatted_s(:my_format_month)
      @day_check_out    = @cimp.check_out.to_formatted_s(:my_format_day)
      @hour_check_out   = @cimp.check_out.to_formatted_s(:my_format_hour)
      @minute_check_out = @cimp.check_out.to_formatted_s(:my_format_minute)
      #render :text=> @hour_check_in and return;
    else
      @trainers = @course_implementation.trainers
      @year_check_in   = @cimp.check_in.to_formatted_s(:my_format_year)
      @month_check_in  = @cimp.check_in.to_formatted_s(:my_format_month)
      @day_check_in    = @cimp.check_in.to_formatted_s(:my_format_day)
      @hour_check_in   = @cimp.check_in.to_formatted_s(:my_format_hour)
      @minute_check_in = @cimp.check_in.to_formatted_s(:my_format_minute)
		
      @year_check_out   = @cimp.check_out.to_formatted_s(:my_format_year)
      @month_check_out  = @cimp.check_out.to_formatted_s(:my_format_month)
      @day_check_out    = @cimp.check_out.to_formatted_s(:my_format_day)
      @hour_check_out   = @cimp.check_out.to_formatted_s(:my_format_hour)
      @minute_check_out = @cimp.check_out.to_formatted_s(:my_format_minute)
    end
	
    @rt = ReservationTrainer.new
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    @coordinators= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")
    @trainers = [] if @trainers.size == 0
  end

  def trainer_book_create
  	@course_implementation = CourseImplementation.find(params[:id])
	
    for trainer in @course_implementation.trainers
      @rt = ReservationTrainer.find(:first, :conditions=>"course_implementation_id=#{@course_implementation.id} AND trainer_id=#{trainer.id}")
      #render :text=> @find_rt.trainer_id and return;
		
      @rt = ReservationTrainer.new(params[:reservation_trainer]) if @rt == nil
      @rt.staff_id = params[:reservation_trainer][:staff_id] #peg membuat tempahan
      @rt.course_implementation_id = @course_implementation.id
      @rt.trainer_id = trainer.id
      @rt.created_on = params[:month_tarikh_tempahan]+"/"+params[:day_tarikh_tempahan]+"/"+params[:year_tarikh_tempahan]
		
      @rt.trainer_checkin = params["year_check_in_#{trainer.id}"] +"-"+ params["month_check_in_#{trainer.id}"] +"-"+ params["day_check_in_#{trainer.id}"] +" "+ params["hour_check_in_#{trainer.id}"] +":"+ params["minute_check_in_#{trainer.id}"]
		
      @rt.trainer_checkout = params["year_check_out_#{trainer.id}"] +"-"+ params["month_check_out_#{trainer.id}"] +"-"+ params["day_check_out_#{trainer.id}"] +" "+ params["hour_check_out_#{trainer.id}"] +":"+ params["minute_check_out_#{trainer.id}"]
					
      @rt.save
    end
	
    flash[:notice] = 'Tempahan(Penceramah) Telah Berjaya Disimpan.'
    redirect_to :controller => 'reservations', :action => 'show_trainer_book', :id =>@course_implementation.id
  end

  def new
    @course_implementation = CourseImplementation.find(params[:id])
    @check = Reservation.find_by_course_implementation_id(@course_implementation.id)
    @staffs= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")
    @reservation = Reservation.new
    @reservation = @check if @check
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    @male = CourseApplication.find_by_sql("select * from course_applications INNER JOIN profiles ON profiles.id = course_applications.profile_id WHERE (student_status_id=4 or student_status_id=2 or student_status_id=5 or student_status_id=7) AND gender_id=1 AND course_implementation_id ='#{@course_implementation.id}'")
    @female = CourseApplication.find_by_sql("select * from course_applications INNER JOIN profiles ON profiles.id = course_applications.profile_id WHERE (student_status_id=4 or student_status_id=2 or student_status_id=5 or student_status_id=7) AND gender_id=2 AND course_implementation_id ='#{@course_implementation.id}'")  
    @coordinators= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")

  end
 
  def new_popup
    new
  end

  def create
    @course_implementation = CourseImplementation.find(params[:id])
	  ds = @course_implementation.date_start-1
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
        sql = "SELECT * FROM sesi_makanan WHERE course_implementation_id=#{@course_implementation.id} and tarikh='#{day[1]}'"
        exist = SesiMakanan.find_by_sql(sql)
        if exist.size == 1
          exist[0].destroy
        end
        @s = SesiMakanan.new(params[:hari][day[1].to_s])
        @s.course_implementation_id = @course_implementation.id
        @s.tarikh = day[1].to_s
        @s.save
      }
    end
	
    @reservation = Reservation.new(params[:reservation])
    @reservation.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
  	#render :text=> @course_implementation.reservations.size and return;
    if @reservation.save
      EspekMailer.hostel_reservation(@course_implementation.id).deliver
      flash[:notice] = 'Tempahan Telah Berjaya Disimpan.'
      if params[:ispopup] and params[:ispopup] == "1"
      	redirect_to :controller => 'reservations', :action => 'show_popup', :id => @reservation
      else
        redirect_to :controller => 'course_applications', :action => 'select_course'
      end
    else
      render :action => 'new'
    end
  end

  def edit_sah
    edit
  end
  
  def update_sah
    @r = Reservation.find(params[:id])
	  @r.status = "1"
	  @r.disahkan_oleh = session[:user].profile.staff.id
	  @r.disahkan_oleh_user = session[:user].login
	  @r.tarikh_sah = Time.now
	  
	  @course_implementation = @r.course_implementation
    if @r.save
	  	EspekMailer.deliver_domestik_sahkan_tempahan(@course_implementation.id)
      flash[:notice] = 'Tempahan Telah Berjaya Disahkan.'
	  	redirect_to :action => 'show_popup', :id => @r
	  end

  end

  def edit
    @reservation = Reservation.find(params[:id])
    @course_implementation = CourseImplementation.find(@reservation.course_implementation_id)
    @check = @reservation
    @coordinators= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")
  end

  def update
    
    @reservation = Reservation.find(params[:id])

    @course_implementation = @reservation.course_implementation
	  ds = @course_implementation.date_start-1
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

    @days.each { |day|
      sql = "SELECT * FROM sesi_makanan WHERE course_implementation_id=#{@course_implementation.id} and tarikh='#{day[1]}'"
      exist = SesiMakanan.find_by_sql(sql)
      if exist.size == 1
        exist[0].destroy
      end
    }
	
    if params[:hari] != nil
      @days.each { |day|
        @s = SesiMakanan.new(params[:hari][day[1].to_s])
        @s.course_implementation_id = @course_implementation.id
        @s.tarikh = day[1].to_s
        @s.save
	
      }
    end

    @reservation.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
    if @reservation.update_attributes(params[:reservation])
      flash[:notice] = 'Tempahan Telah Berjaya Dikemaskini.'
      if params[:ispopup] and params[:ispopup] == "1"
        redirect_to show_popup_reservation_path(:id => @reservation)
      else
        redirect_to :action => 'list'
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    Reservation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
