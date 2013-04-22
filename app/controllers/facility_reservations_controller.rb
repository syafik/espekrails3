# -*- encoding : utf-8 -*-
class FacilityReservationsController < ApplicationController
  layout "standard-layout"
  
  def initialize
	@facility_types = FacilityType.find(:all, :order=>"id")
	@facilities = Facility.find(:all, :order=>"id")
	@facility_categories = FacilityCategory.find(:all, :order=>"id")
	@facility_purposes = FacilityPurpose.find(:all, :order=>"id")
	@profiles = Profile.find(:all, :order=>"id")
	
	@planning_years = FacilityReservation.find_by_sql("SELECT distinct extract(year from date_from)as year from facility_reservations ORDER BY year DESC")
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @facility_reservation_pages, @facility_reservations = paginate :facility_reservations, :per_page => 100
  end
  
  def list_people
    @facility_reservation_pages, @facility_reservations = paginate :facility_reservations, :per_page => 10
  end
  
  def list_future
    @facility_reservation_pages, @facility_reservations = paginate :facility_reservations, :per_page => 10
    #get today
    #t = Time.now
    #today = t.strftime("%m/%d/%Y")
    @username = session[:user].login
    @vid = session[:user].profile_id
    @profile = Profile.find(@vid)
	#@facility_reservations = FacilityReservation.find(:all, :conditions=>"date_from > '"+today+"' AND profile_id = '"+@profile.id+"'")
	#@facility_reservations = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE profile_id = '"+@vid.to_i+"' AND date_from > '03/01/2006' GROUP BY facility_category_id, date_from, date_to")
  end
  

  def show
    facility_category_id = params[:id]
    date_from = params[:date_from]
    date_to = params[:date_to]
    
    @profile = Profile.find(params[:profile_id])
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE facility_category_id = '"+facility_category_id+"' AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' GROUP BY facility_category_id, date_from, date_to ") 
    @facility_reservations = FacilityReservation.find(:all, :conditions=>"date_from = '#{date_from}' and date_to = '#{date_to}' AND profile_id = '#{@profile.id}'")
  end
  
  def new
    @ci=CourseImplementation.find(params[:id])
    @username = session[:user].login
    @vid = session[:user].profile_id
    @profile = Profile.find(@vid)
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    @facility_reservation = FacilityReservation.new
    @staffs= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id AND is_coordinator=1 order by name asc")
  end

  def create
    
    cat = params[:fid]
    datefrom = params[:chkin_date2]+"/"+params[:chkin_date1]+"/"+params[:chkin_date3]
    dateto = params[:chkout_date2]+"/"+params[:chkout_date1]+"/"+params[:chkout_date3]
    bil = params[:kuantiti]
        
    total = cat.size
    totaly = bil.size
    
    #render :text => total
    
    x=0
    totaly.times do
     if (bil[x] != nil || bil[x] != 0) 
      @facility = Facility.find_by_sql("SELECT * FROM facilities WHERE facility_category_id = #{cat[x]} AND id NOT IN (SELECT facility_id FROM facility_reservations WHERE (date_from BETWEEN '"+datefrom+"' AND '"+dateto+"') OR (date_to BETWEEN '"+datefrom+"' AND '"+dateto+"')) ORDER BY code LIMIT #{bil[x].to_i}")
      for fc in @facility
        @facility_reservation = FacilityReservation.new(params[:facility_reservation])
        @facility_reservation.date_from = params[:chkin_date2]+"/"+params[:chkin_date1]+"/"+params[:chkin_date3]
        @facility_reservation.date_to = params[:chkout_date2]+"/"+params[:chkout_date1]+"/"+params[:chkout_date3]
        @facility_reservation.created_on = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in]
        @facility_reservation.facility_id = fc.id
        @facility_reservation.save
      end
     end 
     x=x+1
    end
    
    if @facility_reservation.save
      flash[:notice] = 'Tempahan berjaya.'
      EspekMailer.hantar_tempahan_kemudahan(params[:facility_reservation][:course_implementation_id]).deliver
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  
  end
  
  def new2
    @username = session[:user].login
    @vid = session[:user].profile_id
    @profile = Profile.find(@vid)
    @facility_reservation = FacilityReservation.new
  end
  

  def create2
    pilihan = params[:pilih]
    total = pilihan.size
    #render :text => pilihan[0]
    x=0
    total.times do
      @facility_reservation = FacilityReservation.new(params[:facility_reservation])
      @facility_reservation.date_from = params[:chkin_date2]+"/"+params[:chkin_date1]+"/"+params[:chkin_date3]
      @facility_reservation.date_to = params[:chkout_date2]+"/"+params[:chkout_date1]+"/"+params[:chkout_date3]
      @facility_reservation.facility_id = pilihan[x]
      @facility_reservation.save
      x=x+1
    end
    
    if @facility_reservation.save
      flash[:notice] = 'Tempahan berjaya.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    facility_category_id = params[:id]
    @date_from_edit = params[:date_from]
    @date_to_edit = params[:date_to]
    @profile_to = Profile.find(params[:to_profile_id])
    @profile_cc = Profile.find(params[:cc_profile_id])
    @ci=CourseImplementation.find(params[:course_implementation_id])
    @profile = Profile.find(params[:profile_id])
    @profile_sah = Profile.find(session[:user].profile_id)
    @status = params[:status]
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    @check = FacilityReservation.find_by_course_implementation_id(params[:course_implementation_id])
    @check2 = FacilityCategory.find(params[:id])
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE facility_category_id = '"+facility_category_id+"' AND date_from = '"+@date_from_edit+"' AND date_to = '"+@date_to_edit+"' GROUP BY facility_category_id, date_from, date_to") 
  end

  def update
    @ci=CourseImplementation.find(params[:id])
    @facilities = Facility.find(:all, :conditions=>"facility_category_id=#{params[:facility_category_id]}")
    for p in @facilities
    @facility_reservations = FacilityReservation.find(:all, :conditions=>"facility_id=#{p.id} and course_implementation_id=#{@ci.id} and profile_id=#{params[:facility_reservation][:profile_id]}")
    for q in @facility_reservations
      q.tarikh_sah = params[:month_sah]+"/"+params[:day_sah]+"/"+params[:year_sah]
      q.disahkan_oleh = session[:user].profile_id
      q.update_attributes(params[:facility_reservation])
    end
    end
        flash[:notice] = 'Tempahan Kemudahan Kursus Telah Disahkan.'
        EspekMailer.domestik_sahkan_tempahan_kemudahan(@ci.id).deliver
       redirect_to :action => 'list'
  end
  
  def delete
    facility_category_id = params[:id]
    date_from = params[:date_from]
    date_to = params[:date_to]
    course_implementation_id = params[:course_implementation_id]
    
    @profile = Profile.find(params[:profile_id])
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to,course_implementation_id from facility_reservations inner join facilities ON facilities.id = facility_id WHERE facility_category_id = '"+facility_category_id+"' AND course_implementation_id = '"+course_implementation_id+"' AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' GROUP BY facility_category_id, date_from, date_to, course_implementation_id ") 
    
    #@facility_reservation = FacilityReservation.find(params[:id])
  end

  def dodelete
    facility_category_id = params[:facility_category_id]
    date_from = params[:date_from]
    date_to = params[:date_to]
    course_implementation_id = params[:course_implementation_id]
    
    @facs = FacilityReservation.find_by_sql("SELECT facility_reservations.id FROM facility_reservations INNER JOIN facilities ON facilities.id = facility_id WHERE facility_category_id = '"+facility_category_id+"' AND course_implementation_id = '"+course_implementation_id+"' AND date_from = '"+date_from+"' AND date_to = '"+date_to+"'")
       
    for fac in @facs
      FacilityReservation.find(fac.id).destroy
    end
    
    redirect_to :action => 'list'
  end
  
  def search
    @profiles = Profile.find(:all, :order=>"id")
  end

  def destroy
    FacilityReservation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def pshow
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    
    @profile = Profile.find(params[:profile_id])
    @employment = Employment.find_by_profile_id(params[:profile_id])
    @place = Place.find_by_id(@employment.place_id)
    
    @facilitydate = FacilityReservation.find_by_sql("SELECT distinct date_from, date_to, facility_purposes.description from facility_reservations INNER JOIN facility_purposes ON facility_purposes.id = facility_purpose_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+@date_from+"' AND date_to = '"+@date_to+"' ") 
    
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+@date_from+"' AND date_to = '"+@date_to+"' GROUP BY facility_category_id, date_from, date_to ") 
  end
  
  def pdelete
    @edit = params[:edit]
    date_from = params[:date_from]
    date_to = params[:date_to]
    
    @employment = Employment.find_by_profile_id(params[:profile_id])
    @place = Place.find_by_id(@employment.place_id)
    
    @facilitydate = FacilityReservation.find_by_sql("SELECT distinct date_from, date_to, facility_purposes.description from facility_reservations INNER JOIN facility_purposes ON facility_purposes.id = facility_purpose_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' ") 
    
    @profile = Profile.find(params[:profile_id])
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' GROUP BY facility_category_id, date_from, date_to ") 
    
  end

  def pdodelete
    date_from = params[:date_from]
    date_to = params[:date_to]
    
    pilihan = params[:pilih]
    total = pilihan.size
    
    #render :text => pilihan[0]
    
    x=0
    total.times do
      @facs = FacilityReservation.find_by_sql("SELECT facility_reservations.id FROM facility_reservations INNER JOIN facilities ON facilities.id = facility_id WHERE facility_category_id = '"+pilihan[x]+"' AND date_from = '"+date_from+"' AND date_to = '"+date_to+"'")
      for fac in @facs
         FacilityReservation.find(fac.id).destroy
      end
      x=x+1
    end
    redirect_to :action => 'list_future'
  end
  
  def pedit
    @edit = params[:edit]
    date_from = params[:date_from]
    date_to = params[:date_to]
    
    @employment = Employment.find_by_profile_id(params[:profile_id])
    @place = Place.find_by_id(@employment.place_id)
    
    @facilitydate = FacilityReservation.find_by_sql("SELECT distinct date_from, date_to, facility_purposes.description from facility_reservations INNER JOIN facility_purposes ON facility_purposes.id = facility_purpose_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' ") 
    @bayaran = FacilityReservation.find_by_sql("SELECT sum(price) as harga from facility_reservations INNER JOIN facilities ON facilities.id = facility_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' ") 
    
    @profile = Profile.find(params[:profile_id])
    @facility_reservation = FacilityReservation.find_by_sql("SELECT distinct facility_category_id, count(facility_id) as sum, date_from, date_to from facility_reservations inner join facilities ON facilities.id = facility_id WHERE profile_id = #{params[:profile_id]} AND date_from = '"+date_from+"' AND date_to = '"+date_to+"' GROUP BY facility_category_id, date_from, date_to ") 
  end

  def pupdate
    @username = session[:user].login
    @vid = session[:user].profile_id  #nak guna masa simpan sapa yg amik bayaran - security
    radio = params[:radio]
    
    render :text => radio
    
    
    #@facility_reservation = FacilityReservation.find(params[:id])
    #if @facility_reservation.update_attributes(params[:facility_reservation])
    #  flash[:notice] = 'Tempahan telah dikemaskini.'
    #  redirect_to :action => 'show', :id => @facility_reservation
    #else
    #  render :action => 'edit'
    #end
  end
  
  
end
