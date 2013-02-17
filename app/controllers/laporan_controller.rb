# -*- encoding : utf-8 -*-
class LaporanController < ApplicationController
  #  	require "pdf/writer"
  #  	require "pdf/simpletable"
  layout "standard-layout"

  def initialize
    @states = State.find(:all, :order => "description")
    @genders = Gender.all
    @races = Race.find(:all, :order => "id")
    @profile_statuses = ProfileStatus.all
    @religions = Religion.find(:all, :order => "id")
    @countries = Country.all
    @marital_statuses = MaritalStatus.all
    @places = Place.find(:all, :conditions => "place_type_id = '2'")
    @relationships = Relationship.all
    @cert_levels = CertLevel.all
    @majors = Major.all
    @job_profiles = JobProfile.all
    @titles = Title.find(:all, :order => "description")
    @course_departments = CourseDepartment.all
    #@courses = Course.all
    #@course_implementations = CourseImplementation.all
    super
  end


  def index
    list_laporan
    render :action => 'list_laporan'
  end

  def list_laporan
  end

  def mohon_espek
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      p = dmy(@report_date_from, "/", "-")
      q = dmy(@report_date_to, "/", "-")
      @students = CourseApplication.find(:all, :conditions => "date_apply BETWEEN '#{p}' AND '#{q}'")
    else
      @students = []
    end
  end

  def statistik_kursus_tarikh
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
    end
  end

  def pencapaian_ujian
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
    end

  end

  def pencapaian_ujian_bidang
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
    end
  end

  def penilaian_penceramah
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
    end
  end


  def penilaian_kemudahan
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
    end
  end

  def penilaian_penyelarasan
    if (params[:report1] != nil) && (params[:report2] != nil)
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = '2013-01-01'
      @q = '2013-01-01'
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
    render :layout => "standard-layout"
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
      @report_date_from = params[:report1].first
      @report_date_to = params[:report2].first
      @p = dmy(@report_date_from, "/", "-")
      @q = dmy(@report_date_to, "/", "-")
    else
      @p = @q = dmy(Time.now.to_formatted_s(:my_format_4), "/", "-")
    end
    @audit_trails = AuditTrail.find(:all, :conditions => "created_at BETWEEN '#{@p}' AND '#{@q}'", :order => "created_on DESC")
  end

  private
  def dmy(ymd_date, separator, new_separator)
    a = ymd_date.to_s.split(separator)
    b = "#{a[2]}#{new_separator}#{a[1]}#{new_separator}#{a[0]}"
    return b
  end


end
