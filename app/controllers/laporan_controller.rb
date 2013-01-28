# -*- encoding : utf-8 -*-
class LaporanController < ApplicationController
  	require "pdf/writer"
  	require "pdf/simpletable"
	layout "standard-layout"

	def initialize
	    @states = State.find(:all, :order=>"description")
	    @genders = Gender.find_all
	    @races = Race.find(:all, :order=>"id")
	    @profile_statuses = ProfileStatus.find_all
	    @religions = Religion.find(:all, :order=>"id")
	    @countries = Country.find_all
	    @marital_statuses = MaritalStatus.find_all
	    @places = Place.find(:all, :conditions => "place_type_id = '2'")
	    @relationships = Relationship.find_all
	    @cert_levels = CertLevel.find_all
	    @majors = Major.find_all
	    @job_profiles = JobProfile.find_all
	    @titles = Title.find(:all, :order=>"description")
	    @course_departments = CourseDepartment.find_all
	    #@courses = Course.find_all
	    #@course_implementations = CourseImplementation.find_all
	end


  def index
    list_laporan
  	render :action=>'list_laporan'
  end
  
  def list_laporan
  end
  
  def mohon_espek
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		p = dmy(params[:report1],"/","-")
  		q = dmy(params[:report2],"/","-")
  		@students = CourseApplication.find(:all, :conditions=>"date_apply BETWEEN '#{p}' AND '#{q}'")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@students = []
	end  
  end
  
  def statistik_kursus_tarikh
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end  
  end

  def pencapaian_ujian
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end  
  
  end
  
  def pencapaian_ujian_bidang
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end  
  end

  def penilaian_penceramah
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end    
  end

  
  def penilaian_kemudahan
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end    
  end
  
  def penilaian_penyelarasan
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = '2008-01-01'
		@q = '2008-01-01'
	end    
  end

  def penilaian_isi_kandungan
  	penilaian_penyelarasan
  end

  def senarai_ulasan
  	penilaian_penyelarasan
  end

  def kutipan_yuran
  	penilaian_penyelarasan
  end
  
  def kutipan_yuran_bhg
  	penilaian_penyelarasan
  end

  def status_perlaksanaan
  	@course_implementation = CourseImplementation.find(params[:id])
  	@status_perlaksanaan = StatusPerlaksanaan.find_by_course_implementation_id(@course_implementation.id)
	@check = @status_perlaksanaan
  end
  
  def sp_create
    20.times do |n|
    y = n + 1
    next if params["status_perlaksanaan"]["#{y}"].blank?
    @sp = StatusPerlaksanaan.create(params["status_perlaksanaan"]["#{y}"]) 
    @sp.update_attributes(:course_implementation_id => params[:status_perlaksanaan][:course_implementation_id])
    end

    if @sp.save
      flash[:notice] = 'Status Perlaksanaan Telah DiTambah'
      redirect_to :action => 'status_perlaksanaan', :id => params[:status_perlaksanaan][:course_implementation_id]
    else
      redirect_to :action => 'status_perlaksanaan', :id => params[:status_perlaksanaan][:course_implementation_id]
    end
  end
  
  def sp_update
    @status_perlaksanaan = StatusPerlaksanaan.find_by_course_implementation_id(params[:id])
    for q in @status_perlaksanaan
      q.destroy
    end
    20.times do |n|
    y = n + 1
    next if params["status_perlaksanaan"]["#{y}"].blank?
    @sp = StatusPerlaksanaan.create(params["status_perlaksanaan"]["#{y}"]) 
    @sp.update_attributes(:course_implementation_id => params[:status_perlaksanaan][:course_implementation_id])
    end

    if @sp.save
      flash[:notice] = 'Status Perlaksanaan Telah DiTambah'
      redirect_to :action => 'status_perlaksanaan', :id => params[:status_perlaksanaan][:course_implementation_id]
    else
      redirect_to :action => 'status_perlaksanaan', :id => params[:status_perlaksanaan][:course_implementation_id]
    end
  end

  def audit_trail
  	if (params[:report1] != nil) && (params[:report2] != nil)
  		@p = dmy(params[:report1],"/","-")
  		@q = dmy(params[:report2],"/","-")
		@report_date_from = params[:report1]
		@report_date_to = params[:report2]
	else
		@p = @q = dmy(Time.now.to_formatted_s(:my_format_4),"/","-")
	end    
	@audit_trails = AuditTrail.find(:all, :conditions=>"created_at BETWEEN '#{@p}' AND '#{@q}'" , :order=>"created_on DESC")
  end
  
	private
	def dmy(ymd_date, separator, new_separator)
		a = ymd_date.to_s.split(separator)
		b = "#{a[2]}#{new_separator}#{a[1]}#{new_separator}#{a[0]}"
		return b
	end


end
