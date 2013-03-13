# -*- encoding : utf-8 -*-
class CourseApplicationsController < ApplicationController
  layout "standard-layout"
  #  require "pdf/writer"

  def initialize
    super
  end

  def show_user_cancel
    edit
    @student = @course_application
  end

  def user_cancel
    edit
    @student = @course_application
  end

  def update_user_cancel
    @student = CourseApplication.find(params[:id])
    #params[:course_application][:date_cfm_attend]     = params[:date_cfm_attend_month] + "/" + params[:date_cfm_attend_day] + "/" + params[:date_cfm_attend_year]
    params[:course_application][:student_status_id] = "12" #BATAL KURSUS
    t = Time.now
    today = t.strftime("%m/%d/%Y")
    params[:course_application][:cancel_date] = today

    if @student.update_attributes(params[:course_application])
      #EspekMailer.user_cancel(@student.id)
      flash[:notice] = "Permohonan kursus #{@student.profile.name} telah dibatalkan."
    end

    redirect_to("/course_applications/show_user_cancel/#{@student.id}")
    #redirect_to("/course_applications/unprocessed/#{@student.course_implementation_id}")
  end

  def applicant
    #@students = CourseApplication.find(:all, :select => 'distinct profile_id')
    #    @student_pages = Paginator.new self, CourseApplication.count, 100, @params['page']
    @students = CourseApplication.select('distinct profile_id').
        paginate(:page => params['page'].blank? ? 1 : params[:page], :per_page => 100)
    #    @students = CourseApplication.find(:all, :select => 'distinct profile_id', :limit => @student_pages.items_per_page, :offset => @student_pages.current.offset)
    #render layout : 'standard-layout'
  end

  def index
    list
    render :action => 'list'
  end

  def search_applicant
    #render :layout => 'standard-layout'
  end

  def new_popup
  end


  def search_by_name
    if !params[:query].nil? and params[:query].size == 1
      params[:query] = nil
    end
    unless params[:query].blank?
      @students = CourseApplication.includes(:profile).where("lower(profiles.name) LIKE ?", "%#{params[:query]}%")
      #      @students = CourseApplication.search(params[:query], :include => [:profile], :group => 'profiles.id')
      @students = @students.sort_by { |e| e[:profile_id] }.inject([]) { |m, e| m.last.nil? ? [e] : m.last[:profile_id] == e[:profile_id] ? m : m << e }
    else
      @students = []
    end

    #render :layout => 'standard-layout'
  end

  def search_by_ic
    begin
      sql = "select distinct profiles.id from course_applications,profiles WHERE "
      where = "profiles.id = course_applications.profile_id AND ic_number ILIKE '%#{params[:ic_number]}%'" if params[:ic_number]
      #@students = CourseApplication.find_by_sql("select distinct profiles.id from course_applications,profiles WHERE profiles.id = course_applications.profile_id AND ic_number ILIKE '%#{params[:ic_number]}%'")
      if where != nil
        @students = CourseApplication.find_by_sql(sql + where)
      else
        @students = []
      end
    rescue
      flash['notice'] = 'Carian Tidak Sah'
      redirect_to :action => 'search_applicant'
    end
    #render :layout => 'standard-layout'
  end

  def search_by_phone
    begin
      sql = "select distinct profiles.id from course_applications,profiles WHERE "
      where = "profiles.id = course_applications.profile_id AND mobile ILIKE '%#{params[:phone]}%'" if params[:phone]
      #@students = CourseApplication.find_by_sql("select distinct profiles.id from course_applications,profiles WHERE profiles.id = course_applications.profile_id AND mobile ILIKE '%#{params[:phone]}%'")
      if where != nil
        @students = CourseApplication.find_by_sql(sql + where)
      else
        @students = []
      end
    rescue
      flash['notice'] = 'Carian Tidak Sah'
      redirect_to :action => 'search_applicant'
    end
    #render :layout => 'standard-layout'
  end

  def search_by_state
    @students = CourseApplication.find_by_sql("select distinct profiles.id from course_applications,profiles WHERE profiles.id = course_applications.profile_id AND state_id ILIKE '#{params[:state_id]}'")
  end

  def list
    @student_unprocesses = CourseApplication.find(:all, :conditions => "student_status_id ='1'")
    @student_accepts = CourseApplication.find(:all, :conditions => "student_status_id ='2'")
    @student_confirms = CourseApplication.find(:all, :conditions => "student_status_id ='4'")
    @student_rejects = CourseApplication.find(:all, :conditions => "student_status_id ='3'")
  end

  def courses_for_lookup
    @course_implementations = CourseImplementation.find(:all)
    @headers ||= {}
    @headers[' content-type'] = ' text/javascript'
    render :layout => false
  end

  def places_for_lookup
    #@places = Place.find(:all)
    @headers ||= {}
    @headers[' content-type'] = ' text/javascript'
    render :layout => false
  end

  def grades_for_lookup
    @job_profiles = JobProfile.find(:all, :order => "job_grade")
    @headers ||= {}
    @headers[' content-type'] = ' text/javascript'
    render :layout => false
  end

  def unprocessed
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "date_apply" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND student_status_id=1 ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=1", :order=>"date_apply")

    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")

    @list_title = "SENARAI PEMOHON YANG SEDANG DIPROSES"
    #render layout : 'standard-layout'
  end

  def accepted
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find(params[:course_application_id]) if (params[:course_application_id] && params[:course_application_id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND (student_status_id IN (2)) ORDER BY #{@orderby} #{@arrow}")
      #@students = @course_implementation.selected_applicants
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PEMOHON YANG DIPILIH"
    #render layout : 'standard-layout'
  end

  def accepted_n_jawabhadir
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND (student_status_id IN (2,4)) ORDER BY #{@orderby} #{@arrow}")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PEMOHON YANG DIPILIH"
  end

  def edit_surat_tawaran_select_peserta
    accepted

  end

  def edit_surat_tunda_select_peserta
    accepted_n_jawabhadir
    #render layout : "standard-layout"
  end

  def edit_surat_tunda
    accepted
  end

  def edit_surat_tawaran
    accepted

    t = Time.now
    @current_day= t.strftime("%d")
    @current_month= t.strftime("%m")
    @current_year= t.strftime("%Y")

    if params[:id]
      @schedule = CourseImplementation.find(params[:id])
    elsif params[:course_implementation_code]
      @schedule = CourseImplementation.find_by_code(params[:course_implementation_code])
    else

    end

    @tempoh = "#{@schedule.date_plan_start.to_formatted_s(:my_format_day)} " +
        "#{$MONTH_NAMES[@schedule.date_plan_start.to_formatted_s(:my_format_month).to_i - 1]} " +
        "#{@schedule.date_plan_start.to_formatted_s(:my_format_year)}" +  " HINGGA " +
        "#{@schedule.date_plan_end.to_formatted_s(:my_format_day)} " +
        "#{$MONTH_NAMES[@schedule.date_plan_end.to_formatted_s(:my_format_month).to_i - 1]} " +
        "#{@schedule.date_plan_end.to_formatted_s(:my_format_year)}"

    @tarikh_tutup_kursus = "" +
        "#{@schedule.date_plan_end.to_formatted_s(:my_format_day)} " +
        "#{$MONTH_NAMES[@schedule.date_plan_end.to_formatted_s(:my_format_month).to_i - 1]} " +
        "#{@schedule.date_plan_end.to_formatted_s(:my_format_year)}"
  end

  def rejected
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND student_status_id=3 ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=3", :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PERMOHON YANG DITOLAK"
    #render layout : 'standard-layout'
  end

  def confirmed
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND (student_status_id=4 or student_status_id=5 or student_status_id=6 or student_status_id=8 or student_status_id=9) ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (student_status_id=4 or student_status_id=5 or student_status_id=6 or student_status_id=8 or student_status_id=9)" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PEMOHON YANG MENGESAHKAN KEHADIRAN"
    #render layout : 'standard-layout'
  end

  def confirmednot
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND student_status_id=7 ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=7" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PEMOHON YANG MENGESAHKAN TIDAK HADIR"
    #render layout : 'standard-layout'
  end

  def hadir
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND (student_status_id=5 or student_status_id=8 or student_status_id=9) ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 or student_status_id=8 or student_status_id=9)" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PESERTA YANG MENGHADIRI KURSUS"
    #render layout : 'standard-layout'
  end

  def cetak_pengesahan

  end

  def cetak_direktory

    @course_application = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")

    if @course_application

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{params[:id]}' AND (student_status_id=5 or student_status_id=8 or student_status_id=9) ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 or student_status_id=8 or student_status_id=9)" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI DIREKTORI PESERTA YANG MENGHADIRI KURSUS"
  end


  def takhadir
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND (student_status_id=6 or student_status_id=4) ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (student_status_id=6)" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PESERTA YANG TIDAK MENGHADIRI KURSUS"
    #render layout : 'standard-layout'
  end

  def norespon
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND student_status_id=2 ORDER BY #{@orderby} #{@arrow}")
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=2" , :order=>"date_apply")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    @list_title = "SENARAI PERMOHONAN YANG MASIH TIADA JAWAPAN SETELAH DIPILIH"
    #render layout : 'standard-layout'
  end

  def all
    @course_implementation = CourseImplementation.find(params[:course_application_id]) if (params[:course_application_id] && params[:course_application_id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id}", :order=>"#{@orderby}")
      @students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' order by #{@orderby} #{@arrow}")

    else
      @students = []
      render :action => "search_not_found"
    end
    @courses = Course.find(:all, :order => "name")
    #render :layout => "standard-layout"
  end

  def search
    #render :layout => "standard-layout"
  end

  def search_not_found
  end

  def show
    init_load
    @course_application = CourseApplication.find(params[:course_application_id]) unless params[:course_application_id].blank?
    @course_application = CourseApplication.find(params[:id]) unless params[:id].blank?
    @student = @course_application
    @relative = Relative.find_by_profile_id(@course_application.profile_id)
    @employment = Employment.find_by_profile_id(@course_application.profile_id)
    @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
  end

  def show_after_create
    show
  end

  def show_after_
    create_peserta
    show
  end

  def show_after_dr
    show
  end

  def show_after_create_dr
    show
  end

  def new
    init_load
    @courses = Course.all
    @course_implementation = CourseImplementation.find(params[:course_application_id]) if params[:course_application_id]
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
    @course_application = CourseApplication.new
    #render layout : 'standard-layout'
  end

  def new_peserta
    init_load
    @courses = Course.all
    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
    @course_application = CourseApplication.new
    #render :layout => "standard-layout"
  end

  def new_but_peserta_already_exist
    init_load
    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation][:code]) if params[:course_implementation]
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
    @course_application = CourseApplication.new
    #render layout : "standard-layout"
  end

  def new_for_logged_in_user
    init_load
    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation][:code]) if params[:course_implementation]
    @profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
    @course_application = CourseApplication.new
    #render layout : "standard-layout"
  end

  def edit_by_user
    edit
    #render layout : "standard-layout"
  end

  def send_successful_email(user, cid)
    EspekMailer.deliver_user_successful(user, cid)
    #EspekMailer.deliver_coordinator_successful
  end

  def test_mail
    EspekMailer.deliver_test_mail
  end

  def create_for_logged_in_user
    init_load
    @profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    t = Time.now
    now_year = t.strftime("%Y")
    now_month = t.strftime("%m")
    now_day = t.strftime("%d")

    if params[:course_application]
      @course_application = CourseApplication.new(params[:course_application])
      @course_application.date_apply = now_month + "/" + now_day + "/" + now_year
      @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
      @course_application.course_implementation_id = @course_implementation.id
      @course_application.course_id = @course_implementation.course_id
      @course_application.profile_id = @profile.id
      @course_application.is_apply_online = 1
      @course_application.nama_pejabat = @profile.opis
      @course_application.address1 = params[:profile][:address1]
      @course_application.address2 = params[:profile][:address2]
      @course_application.address3 = params[:profile][:address3]

    end

    if @course_application.save
      #flash[:notice] = 'Permohonan berjaya disimpan'
      #redirect_to("/course_applications/save_for_logged_in_user_successful.rhtml")
      EspekMailer.deliver_user_recorded(session[:user], @course_implementation.id)
      EspekMailer.deliver_ketua_jabatan(@course_application.id)

      if @profile.update_attributes(params[:profile])
        flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
      else
        render :action => 'new_for_logged_in_user'
      end

      @qualifications = @course_application.profile.qualifications
      for q in @qualifications
        q.destroy
      end
      if params[:cert_level_ids]
        params[:cert_level_ids].size.times do |i|
          q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                                :pengkhususan => params[:majors][i],
                                :institution => params[:institutions][i],
                                :year_end => params[:year_ends][i])

          @profile.qualifications.push(q)
        end
      end

      @employment = Employment.find_by_profile_id(@profile.id)
      if @employment
        arr = params[:job_profile_name].split(",")
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
        params[:employment][:job_profile_id] = job_profile.id if job_profile

        if @employment.update_attributes(params[:employment])
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_for_logged_in_user'
        end
      else
        @employment = Employment.new(params[:employment])
        @employment.profile = @profile
        arr = params[:job_profile_name].split(",")
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
        @employment.job_profile_id = job_profile.id if job_profile
        if @employment.save
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_for_logged_in_user'
        end
      end

      @relative = Relative.find_by_profile_id(@profile.id)
      if @relative
        if @relative.update_attributes(params[:relative])
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_for_logged_in_user'
        end
      else
        @relative = Relative.new(params[:relative])
        @relative.profile = @profile
        if @relative.save
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_for_logged_in_user'
        end
      end

      @qualifications = @profile.qualifications
      for q in @qualifications
        q.destroy
      end
      if params[:cert_level_ids] and params[:cert_level_ids].size > 0
        params[:cert_level_ids].size.times do |i|
          q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                                :pengkhususan => params[:majors][i],
                                :institution => params[:institutions][i],
                                :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""

          @profile.qualifications.push(q) if q
        end
      end


    else
      flash[:notice] = 'Permohonan gagal disimpan, sila cuba sekali lagi'
      @profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
      render :action => 'new_for_logged_in_user'
    end
  end

  def user_daftar
    @course_application = CourseApplication.find(params[:id])
    @course_implementation = @course_application.course_implementation
    @profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
  end

  def user_daftar_create
    #@profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
    #@relative = Relative.find_by_profile_id(@profile.id)
    #@employment = Employment.find_by_profile_id(@profile.id)
    #@qualification =Qualification.find_by_profile_id(@profile.id)

    @course_application = CourseApplication.find(params[:id])
    if @course_application.update_attributes(:student_status_id => 5)
      flash[:notice] = 'Permohonan berjaya dikemaskini.'
    else
      render :action => 'user_daftar'
    end

    @profile = @course_application.profile
    if @profile.update_attributes(params[:profile])
      flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
    else
      render :action => 'user_daftar'
    end

    #@employment = Employment.find_by_profile_id(@profile.id)
    if @employment
      arr = params[:job_profile_name].split(",")
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
      params[:employment][:job_profile_id] = job_profile.id if job_profile

      if @employment.update_attributes(params[:employment])
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'user_daftar'
      end
    else
      @employment = Employment.new(params[:employment])
      @employment.profile = @profile
      arr = params[:job_profile_name].split(",")
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
      @employment.job_profile_id = job_profile.id if job_profile
      if @employment.save
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'user_daftar'
      end
    end

    @qualifications = @course_application.profile.qualifications
    for q in @qualifications
      q.destroy
    end
    if params[:cert_level_ids] and params[:cert_level_ids].size > 0
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :pengkhususan => params[:majors][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""

        @profile.qualifications.push(q) if q
      end
    end

    if @profile.update_attributes(params[:profile])
      flash[:notice] = '<br>Pendaftaran berjaya.'
      redirect_to("/user_applications/attend")
    else
      flash[:notice] = 'Pendaftaran gagal, sila cuba sekali lagi'
      @profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
      render :action => 'user_daftar'
    end
  end

  def cetak_for_logged_in_user
    @course_application = CourseApplication.find(params[:id]) if params[:id]
  end

  def create_but_peserta_already_exist
    init_load
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    if params[:course_application]
      @course_application = CourseApplication.new(params[:course_application])
      @course_application.date_apply = params[:date_apply_month] + "/" + params[:date_apply_day] + "/" + params[:date_apply_year]
      @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
      @course_application.profile_id = @profile.id
      #get back to this, not sure why set status sahkan hadir(sebelum ni tamat) untuk peserta gantian
      @course_application.student_status_id = 4 if params[:dr]
      @course_application.nama_pejabat = @profile.opis
      @course_application.address1 = params[:profile][:address1]
      @course_application.address2 = params[:profile][:address2]
      @course_application.address3 = params[:profile][:address3]
    end

    @course_implementation = CourseImplementation.find_by_code("#{params[:course_implementation][:code]}")
    if @course_implementation
      @course_application.course_implementation_id = @course_implementation.id
      @course_application.course_id = @course_implementation.course_id
    end

    if @course_application.save
      flash[:notice] = 'Application was successfully recorded.'
      if @profile.update_attributes(params[:profile])
        flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
        @certificate = Certificate.new(:course_application_id => "#{@course_application.id}")
        @certificate.save
      else
        render :action => 'new_but_peserta_already_exist'
      end

      @qualifications = @course_application.profile.qualifications
      for q in @qualifications
        q.destroy
      end
      if params[:cert_level_ids]
        params[:cert_level_ids].size.times do |i|
          q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                                :pengkhususan => params[:majors][i],
                                :institution => params[:institutions][i],
                                :year_end => params[:year_ends][i])

          @profile.qualifications.push(q)
        end
      end

      @employment = Employment.find_by_profile_id(@profile.id)
      if @employment
        arr = params[:job_profile_name].split(",")
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
        params[:employment][:job_profile_id] = job_profile.id if job_profile
        if @employment.update_attributes(params[:employment])
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_but_peserta_already_exist'
        end
      else
        @employment = Employment.new(params[:employment])
        @employment.profile = @profile
        arr = params[:job_profile_name].split(",")
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
        @employment.job_profile_id = job_profile.id if job_profile
        if @employment.save
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_but_peserta_already_exist'
        end
      end

      @relative = Relative.find_by_profile_id(@profile.id)
      if @relative
        if @relative.update_attributes(params[:relative])
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_but_peserta_already_exist'
        end
      else
        @relative = Relative.new(params[:relative])
        @relative.profile = @profile
        if @relative.save
          flash[:notice] = 'Data berjaya dikemaskini.'
        else
          render :action => 'new_but_peserta_already_exist'
        end
      end

      redirect_to :action => 'show_after_dr', :id => @course_application
    else
      render :action => 'new_but_peserta_already_exist'
    end

  end

  def accept_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      if @student.update_attributes(:student_status_id => "2", :approval_id => "2")
        @student.update_attributes(:supervisor_profile_id => "#{session[:user].profile.id}")
        #EspekMailer.deliver_user_selected(@student.profile.user, @student.course_implementation_id)
      end
    end
    redirect_to("/course_applications/accepted/#{@student.course_implementation_id}?apply_status=accepted")
  end

  def reason_rejected
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @students = CourseApplication.find(params[:course_application_ids])
  end

  def reject_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      if @student.update_attributes(:student_status_id => "3", :approval_id => "3")
        @student.update_attributes(:supervisor_profile_id => "#{session[:user].profile.id}")
        #EspekMailer.deliver_user_rejected(@student.profile.user, @student.course_implementation_id)
      end
    end
    redirect_to("/course_applications/rejected/#{@student.course_implementation_id}?apply_status=rejected")
  end

  def reject_selected_with_reason
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      reason = params[:reasons][id]
      if @student.update_attributes(:student_status_id => "3", :approval_id => "3", :reason => reason)
        @student.update_attributes(:supervisor_profile_id => "#{session[:user].profile.id}")
        #EspekMailer.deliver_user_rejected(@student.profile.user, @student.course_implementation_id)
      end
    end
    redirect_to("/course_applications/rejected/#{@student.course_implementation_id}?apply_status=rejected")
  end

  def sah_hadir_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      @student.update_attributes(:student_status_id => "4")
      @student.update_attributes(:supervisor_profile_id => "#{session[:user].profile.id}")
    end
    redirect_to("/course_applications/confirmed/#{@student.course_implementation_id}?apply_status=confirmed")
  end

  def konaitokimeta
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      @student.update_attributes(:student_status_id => "7")
      @student.update_attributes(:supervisor_profile_id => "#{session[:user].profile.id}")
    end
    redirect_to("/course_applications/confirmednot/#{@student.course_implementation_id}?apply_status=confirmednot")
  end

  def create
    init_load
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = Date.new(params[:y_dob],params[:m_dob],params[:d_dob])
    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save

    arr = params[:job_profile_name].split(",")
    job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
    params[:employment][:job_profile_id] = job_profile.id if job_profile
    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save

    @course_application = CourseApplication.new(params[:course_application]) if @params[:course_application]
    @course_application.date_apply = params[:date_apply_month] + "/" + params[:date_apply_day] + "/" + params[:date_apply_year]
    @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
    @course_application.nama_pejabat = @profile.opis
    @course_application.address1 = params[:profile][:address1]
    @course_application.address2 = params[:profile][:address2]
    @course_application.address3 = params[:profile][:address3]
    #@course_implementation = CourseImplementation.find(params[:course_application][:course_implementation_id])
    @course_implementation = CourseImplementation.find_by_code("#{params[:course_implementation][:code]}")
    if @course_implementation
      @course_application.course_implementation_id = @course_implementation.id
      @course_application.course_id = @course_implementation.course_id
    end

    if params[:cert_level_ids]
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :pengkhususan => params[:majors][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i])

        @profile.qualifications.push(q)
      end
    end

    #@qualification = Qualification.new(params[:qualification]) if params[:qualification]
    #@profile.qualifications.push(@qualification)
    if @profile.save
      @course_application.profile = @profile
      if @course_application.save
        flash[:notice] = "Permohonan telah berjaya disimpan"
        redirect_to :action => 'show_after_create', :id => @course_application
      else
        @profile.destroy
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end

  def create_peserta
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save

    arr = params[:job_profile_name].split(",")
    job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
    params[:employment][:job_profile_id] = job_profile.id if job_profile
    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save

    @course_application = CourseApplication.new(params[:course_application]) if @params[:course_application]
    @course_application.date_apply = params[:date_apply_month] + "/" + params[:date_apply_day] + "/" + params[:date_apply_year]
    @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
    #@course_implementation = CourseImplementation.find(params[:course_application][:course_implementation_id])
    @course_implementation = CourseImplementation.find_by_code("#{params[:course_implementation][:code]}")
    if @course_implementation
      @course_application.course_implementation_id = @course_implementation.id
      @course_application.course_id = @course_implementation.course_id
    end

    if params[:cert_level_ids]
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :pengkhususan => params[:majors][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i])

        @profile.qualifications.push(q)
      end
    end

    #@qualification = Qualification.new(params[:qualification]) if params[:qualification]
    #@profile.qualifications.push(@qualification)
    if @profile.save
      @course_application.profile = @profile
      # tak pasti kenapa nak set student status
      #@course_application.student_status_id = 2
      @course_application.student_status_id = 4 if params[:dr]
      if @course_application.save
        @certificate = Certificate.new(:course_application_id => "#{@course_application.id}")
        @certificate.save
        flash[:notice] = "Peserta telah berjaya disimpan"
        redirect_to :action => 'show_after_create_dr', :id => @course_application
      else
        @profile.destroy
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end

  def edit
    init_load
    @course_application = CourseApplication.find(params[:id])
    @course_implementation = @course_application.course_implementation
    @profile = @course_application.profile
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    if @employment
      @job_profile = @employment.job_profile
    else
      @employment = Employment.new
      @job_profile = JobProfile.new
    end
    #render layout : 'standard-layout'
  end

  def update
    @course_application = CourseApplication.find(params[:id])
    if (params[:by_user])
      if (@course_application.student_status_id == 8)
        flash[:notice] = 'Tidak dibenarkan kemaskini selepas kursus tamat.';
        redirect_to :controller => 'user_applications',
                    :action => 'show',
                    :id => @course_application.id and return;
      end
    end
    @course_application.date_apply = params[:date_apply_month] + "/" + params[:date_apply_day] + "/" + params[:date_apply_year]
    @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
    @course_application.nama_pejabat = params[:profile][:opis]
    @course_application.address1 = params[:profile][:address1]
    @course_application.address2 = params[:profile][:address2]
    @course_application.address3 = params[:profile][:address3]
    if @course_application.update_attributes(params[:course_application])
      flash[:notice] = 'Permohonan berjaya dikemaskini.'
    else
      render :action => 'edit'
    end

    @profile = @course_application.profile
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    if @profile.update_attributes(params[:profile])
      flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
    else
      render :action => 'edit'
    end

    @employment = Employment.find_by_profile_id(@profile.id)
    if @employment
      arr = params[:job_profile_name].split(",")
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
      params[:employment][:job_profile_id] = job_profile.id if job_profile

      if @employment.update_attributes(params[:employment])
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'new_for_logged_in_user'
      end
    else
      @employment = Employment.new(params[:employment])
      @employment.profile = @profile
      arr = params[:job_profile_name].split(",")
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
      @employment.job_profile_id = job_profile.id if job_profile
      if @employment.save
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'new_for_logged_in_user'
      end
    end

    @qualifications = @course_application.profile.qualifications
    for q in @qualifications
      q.destroy
    end
    if params[:cert_level_ids] and params[:cert_level_ids].size > 0
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :pengkhususan => params[:majors][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""

        @profile.qualifications.push(q) if q
      end
    end

    if @profile.update_attributes(params[:profile])
      flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
      if (params[:by_user])
        EspekMailer.deliver_edit_by_user(@course_application.id)
        redirect_to :controller => 'user_applications', :action => 'show', :id => @course_application and return
      else
        redirect_to :action => 'show', :id => @course_application and return
      end
    else
      render :action => 'edit'
    end

  end

  def select_course
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")
    #    cur_year = Time.now.to_formatted_s(:my_format_year).to_s
    params[:year_start] = Time.now.strftime("%Y") if params[:year_start].blank?

    staff_id = nof { session[:user].profile.staff.id }
    if staff_id != nil
      @course_implementations = CourseImplementation.find(:all,
                                                          :conditions => ["extract(year from date_plan_start) = ? AND (coordinator1 = #{staff_id} OR coordinator2 = #{staff_id})", params[:year_start]],
                                                          :order => "date_plan_start DESC")
    else
      @course_implementations = []
    end
    #render layout : "standard-layout"
  end

  def destroy
    CourseApplication.find(params[:id]).destroy
    redirect_to :action => 'select_course'
    #redirect_to :action => 'list'
  end

  #def edit_surat_tawaran
  #end

  def view_surat_tawaran

  end

  def rujukan_kami
    @surats = SuratTawaranContent.find(:all, :conditions => "course_department_id = #{params[:id]}")
  end

  def cetak_surat_tawaran
    #filename = "surat_tawaran.pdf"
    filename = "surat_tawaran_"+ "#{params[:course_implementation_id]}.pdf"

    course_implementation = CourseImplementation.find(params[:course_implementation_id])
    course = Course.find(course_implementation.course_id)
    rujukan = LatestOfferReference.find_by_course_department_id(course.course_department_id)
    if rujukan
      rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
    else
      rujukan = LatestOfferReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => course.course_department_id)
      rujukan.save
    end
    params[:surat_tawaran_content][:is_cetakan_komputer] = params[:is_cetakan_komputer]
    params[:surat_tawaran_content][:format_surat] = params[:format_surat]
    params[:surat_tawaran_content][:course_department_id] = course.course_department_id
    params[:surat_tawaran_content][:course_implementation_id] = params[:course_implementation_id]
    params[:surat_tawaran_content][:ref_no] = params[:rujukan_kami]
    params[:surat_tawaran_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]
    #ads_letter = SuratTawaranContent.find_by_course_implementation_id(params[:course_implementation_id])
    #if ads_letter
    #  ads_letter.update_attributes(params[:surat_tawaran_content])
    #else
    #  new_ads_letter = SuratTawaranContent.new(params[:surat_tawaran_content])
    #  new_ads_letter.save!
    #end

    @zero_paragraph = "Dengan hormatnya saya diarah merujuk kepada perkara di atas."

    @first1_paragraph = "2.\s\sSukacita dimaklumkan bahawa pegawai seperti nama di atas telah dipilih untuk menghadiri kursus #{params[:course_implementation_name].titleize} (#{params[:course_implementation_code]}) di Institut Tanah dan Ukur Negara (INSTUN), Kementerian Sumber Asli dan Alam Sekitar."
    @first_paragraph = "2. \s\sSukacita dimaklumkan bahawa pegawai seperti nama diatas telah terpilih untuk menghadiri kursus berkenaan di Institut Tanah dan Ukur Negara (INSTUN),Kementerian Sumber Asli dan Alam Sekitar. "
    @second2_paragraph = "3.\s\s\s\sBersama-sama ini disertakan dokumen-dokumen berkaitan kursus di atas iaitu:\n\n\s\s\s\s\s\s\s 3.1\s\s\s\sBorang Pengesahan Kehadiran seperti di Lampiran A \n\s\s\s\s\s\s\s 3.2\s\s\s\sMaklumat kursus seperti di Lampiran B \n\s\s\s\s\s\s\s 3.3\s\s\s\sPeta Lokasi INSTUN di Lampiran C"
    @second_paragraph = "3.\s\s\s\sBersama-sama ini disertakan dokumen-dokumen berkaitan kursus di atas iaitu:\n\n\s\s\s\s\s\s\s 3.1\s\s\s\sBorang Pengesahan Kehadiran seperti di Lampiran A \n\s\s\s\s\s\s\s 3.2\s\s\s\sMaklumat kursus seperti di Lampiran B \n\s\s\s\s\s\s\s 3.3\s\s\s\sPeta Lokasi INSTUN di Lampiran C"
    @third_paragraph = "4.\s\s\s\sPeserta dikehendaki membaca / meneliti dokumen-dokumen di para 3 di atas.Peserta juga akan dikenakan bayaran pendaftaran kursus sebanyak RM30.00 (tunai). Resit rasmi akan dikeluarkan bagi membolehkan para peserta membuat tuntutan semula daripada Jabatan/Agensi masing-masing."
    @fourth_paragraph = "5.\s\s\s\sYuran Pendaftaran Kursus sebanyak <b>RM30.00</b> akan dikenakan kepada peserta-peserta kursus. Yuran Pendaftaran Kursus ini boleh dituntut dari Jabatan masing-masing dengan menggunakan resit yang akan dikeluarkan oleh pihak INSTUN."

    @fifth_paragraph = "6.\s\s\s\sSemasa berkursus, para peserta adalah <b>diwajibkan</b> untuk menyertai sebarang aktiviti yang dianjurkan oleh pihak INSTUN. " +
        "Para peserta kursus adalah diminta untuk membawa bersama <b>pakaian sukan/riadah, alatulis dan peralatan yang sesuai</b>" +
        " untuk aktiviti-aktiviti tersebut. Untuk kemudahan para peserta kursus, bersama ini disertakan pelan lokasi INSTUN."

    @sixth_paragraph = "5.\s\s\s\sKerjasama tuan/puan adalah dipohon untuk mengesahkan kehadiran melalui faks seperti di"

    @seventh_paragraph ="Sekiranya para peserta kursus mempunyai sebarang pertanyaan atau kemusykilan sila hubungi :"

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    @tarikh = params[:dateline]
    @perkara = params[:surat_tawaran_content][:perkara]
    @perenggan = params[:surat_tawaran_content][:perenggan]

    @signature = Signature.find_by_filename(params[:signature_file])

    if @signature
      @tandatangan_nama = @signature.person_name.upcase
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "                     "
      @tandatangan_jawatan = "                     "
    end

    #@is_cetakan_komputer = params[:is_cetakan_komputer].to_i

    if params[:is_cetakan_komputer].to_i == 0
      if RUBY_PLATFORM == "i386-mswin32"
        @signature_file = "public/signatures/#{params[:signature][:filename]}"
      else
        @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature][:filename]}"
      end

      if !params[:signature][:filename] or params[:signature][:filename] == ""
        @signature_file = ""
      end
    end

    @perkara2 = "<b>PENGESAHAN KEHADIRAN KURSUS #{params[:nama_kursus]} #{params[:tempoh]} DI INSTITUT TANAH DAN UKUR NEGARA (INSTUN)</b>"
    @course_department = params[:course_department]
    @penyelaras_telefon = params[:penyelaras_telefon]
    @penyelaras_ext = params[:penyelaras_ext]
    @penyelaras_fax = params[:penyelaras_fax]
    @penyelaras_email = params[:penyelaras_email]
    @penyelaras_email2 = params[:penyelaras_email2]

    @course_implementation_name = params[:course_implementation_name]
    @course_implementation_code = params[:course_implementation_code]

    @courses = Course.find_by_sql("SELECT c.* FROM courses c, course_implementations ci where ci.course_id=c.id and ci.code ilike '#{params[:course_implementation_code]}' limit 1")
    @location_name = CourseLocation.find(@courses[0].course_location_id)
    @department_name = CourseDepartment.find(@courses[0].course_department_id)
    @reference_name = @courses[0].reference
    @reference_name = "-" if (@reference_name==nil or @reference_name.strip=="")
    @duration = params[:duration].titleize
    @check_in = params[:check_in]
    @check_in_hour = params[:check_in_hour]
    @check_in_minute = params[:check_in_minute]

    params[:briefing] = " " if params[:briefing].strip == ""
    @briefing = params[:briefing]
    params[:briefing_hour] = " " if params[:briefing_hour].strip == ""
    @briefing_hour = params[:briefing_hour]
    params[:briefing_minute] = " " if params[:briefing_minute].strip == ""
    @briefing_minute = params[:briefing_minute]
    params[:check_in] = " " if params[:check_in].strip == ""
    @check_in = params[:check_in]
    params[:check_out] = " " if params[:check_out].strip == ""
    @check_out = params[:check_out]
    params[:hour_closed1] = " " if params[:hour_closed1].strip == ""
    @hour_closed1 = params[:hour_closed1]
    params[:hour_closed2] = " " if params[:hour_closed2].strip == ""
    @hour_closed2 = params[:hour_closed2]
    params[:minute_closed1] = " " if params[:minute_closed1].strip == ""
    @minute_closed1 = params[:minute_closed1]
    params[:minute_closed2] = " " if params[:minute_closed2].strip == ""
    @minute_closed2 = params[:minute_closed2]
    @contact1 = Staff.find(params[:contact_officer_id].to_i)
    if params[:contact_officer_id2].strip == ""
      @contact2=" "
    else
      @contact2 = Staff.find(params[:contact_officer_id2].to_i)
    end

    @tempat_suaikenal = params[:tempat_suaikenal]

    @students = CourseApplication.find(params[:course_application_ids])

    #@students = CourseApplication.find(params[:course_application_ids])
    #for student in @students
    #  gen_pdf_all_format_3(student, "#{student.id.to_s}.pdf")
    #end

    #gen_pdf_all_format_1(filename) if params[:format_surat].to_i == 1 or params[:format_surat].to_i == 3
    #gen_pdf_all_format_2(filename) if params[:format_surat].to_i == 2 or params[:format_surat].to_i == 4
    #
    #redirect_to("/surat/" + filename)
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => filename,
               :page_size => 'A4'
      end
    end
  end

  def cetak_surat_tunda
    filename = "surat_penundaan_"+ "#{params[:course_implementation_id]}.pdf"

    course_implementation = CourseImplementation.find(params[:course_implementation_id])
    course = Course.find(course_implementation.course_id)
    #rujukan = LatestOfferReference.find_by_course_department_id(course.course_department_id)	
    #if rujukan
    #	rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
    #else
    #	rujukan = LatestOfferReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => course.course_department_id)
    #	rujukan.save
    #end
    params[:surat_tawaran_content][:is_cetakan_komputer] = params[:is_cetakan_komputer]
    params[:surat_tawaran_content][:format_surat] = params[:format_surat]
    params[:surat_tawaran_content][:course_department_id] = course.course_department_id
    params[:surat_tawaran_content][:course_implementation_id] = params[:course_implementation_id]
    params[:surat_tawaran_content][:ref_no] = params[:rujukan_kami]
    params[:surat_tawaran_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]
    ads_letter = SuratTawaranContent.find_by_course_implementation_id(params[:course_implementation_id])
    #if ads_letter
    #  ads_letter.update_attributes(params[:surat_tawaran_content])
    #else
    #  new_ads_letter = SuratTawaranContent.new(params[:surat_tawaran_content])
    #  new_ads_letter.save!
    #end

    @zero_paragraph = "Dengan hormatnya saya diarah merujuk kepada perkara di atas."

    @first1_paragraph = "2.\s\s Tunda. Sukacita dimaklumkan bahawa pegawai seperti nama di atas telah dipilih untuk menghadiri kursus #{params[:course_implementation_name].titleize} (#{params[:course_implementation_code]}) di Institut Tanah dan Ukur Negara (INSTUN), Kementerian Sumber Asli dan Alam Sekitar."
    @first_paragraph = "2. \s\sSukacita dimaklumkan bahawa pegawai seperti nama diatas telah terpilih untuk menghadiri kursus berkenaan di Institut Tanah dan Ukur Negara (INSTUN),Kementerian Sumber Asli dan Alam Sekitar. "
    @second2_paragraph = "3.\s\s\s\sBersama-sama ini disertakan dokumen-dokumen berkaitan kursus di atas iaitu:\n\n\s\s\s\s\s\s\s 3.1\s\s\s\sBorang Pengesahan Kehadiran seperti di Lampiran A \n\s\s\s\s\s\s\s 3.2\s\s\s\sMaklumat kursus seperti di Lampiran B \n\s\s\s\s\s\s\s 3.3\s\s\s\sPeta Lokasi INSTUN di Lampiran C"
    @second_paragraph = "3.\s\s\s\sBersama-sama ini disertakan dokumen-dokumen berkaitan kursus di atas iaitu:\n\n\s\s\s\s\s\s\s 3.1\s\s\s\sBorang Pengesahan Kehadiran seperti di Lampiran A \n\s\s\s\s\s\s\s 3.2\s\s\s\sMaklumat kursus seperti di Lampiran B \n\s\s\s\s\s\s\s 3.3\s\s\s\sPeta Lokasi INSTUN di Lampiran C"
    @third_paragraph = "4.\s\s\s\sPeserta dikehendaki membaca / meneliti dokumen-dokumen di para 3 di atas.Peserta juga akan dikenakan bayaran pendaftaran kursus sebanyak RM30.00 (tunai). Resit rasmi akan dikeluarkan bagi membolehkan para peserta membuat tuntutan semula daripada Jabatan/Agensi masing-masing."
    @fourth_paragraph = "5.\s\s\s\sYuran Pendaftaran Kursus sebanyak <b>RM30.00</b> akan dikenakan kepada peserta-peserta kursus. Yuran Pendaftaran Kursus ini boleh dituntut dari Jabatan masing-masing dengan menggunakan resit yang akan dikeluarkan oleh pihak INSTUN."

    @fifth_paragraph = "6.\s\s\s\sSemasa berkursus, para peserta adalah <b>diwajibkan</b> untuk menyertai sebarang aktiviti yang dianjurkan oleh pihak INSTUN. " +
        "Para peserta kursus adalah diminta untuk membawa bersama <b>pakaian sukan/riadah, alatulis dan peralatan yang sesuai</b>" +
        " untuk aktiviti-aktiviti tersebut. Untuk kemudahan para peserta kursus, bersama ini disertakan pelan lokasi INSTUN."

    @sixth_paragraph = "5.\s\s\s\sKerjasama tuan/puan adalah dipohon untuk mengesahkan kehadiran melalui faks seperti di"

    @seventh_paragraph ="Sekiranya para peserta kursus mempunyai sebarang pertanyaan atau kemusykilan sila hubungi :"

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    @tarikh = params[:dateline]
    @perkara = params[:surat_tawaran_content][:perkara]
    @perenggan = params[:surat_tawaran_content][:perenggan]

    @signature = Signature.find_by_filename(params[:signature_file])

    if @signature
      @tandatangan_nama = @signature.person_name.upcase
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "                     "
      @tandatangan_jawatan = "                     "
    end

    #@is_cetakan_komputer = params[:is_cetakan_komputer].to_i

    if params[:is_cetakan_komputer].to_i == 0
      if RUBY_PLATFORM == "i386-mswin32"
        @signature_file = "public/signatures/#{params[:signature][:filename]}"
      else
        @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature][:filename]}"
      end

      if !params[:signature][:filename] or params[:signature][:filename] == ""
        @signature_file = ""
      end
    end

    @perkara2 = "<b>PENGESAHAN KEHADIRAN KURSUS #{params[:nama_kursus]} #{params[:tempoh]} DI INSTITUT TANAH DAN UKUR NEGARA (INSTUN)</b>"
    @course_department = params[:course_department]
    @penyelaras_telefon = params[:penyelaras_telefon]
    @penyelaras_ext = params[:penyelaras_ext]
    @penyelaras_fax = params[:penyelaras_fax]
    @penyelaras_email = params[:penyelaras_email]
    @penyelaras_email2 = params[:penyelaras_email2]

    @course_implementation_name = params[:course_implementation_name]
    @course_implementation_code = params[:course_implementation_code]

    @courses = Course.find_by_sql("SELECT c.* FROM courses c, course_implementations ci where ci.course_id=c.id and ci.code ilike '#{params[:course_implementation_code]}' limit 1")
    @location_name = CourseLocation.find(@courses[0].course_location_id)
    @department_name = CourseDepartment.find(@courses[0].course_department_id)
    @reference_name = @courses[0].reference
    @reference_name = "-" if (@reference_name==nil or @reference_name.strip=="")
    @duration = params[:duration].titleize
    @check_in = params[:check_in]
    @check_in_hour = params[:check_in_hour]
    @check_in_minute = params[:check_in_minute]

    params[:briefing] = " " if params[:briefing].strip == ""
    @briefing = params[:briefing]
    params[:briefing_hour] = " " if params[:briefing_hour].strip == ""
    @briefing_hour = params[:briefing_hour]
    params[:briefing_minute] = " " if params[:briefing_minute].strip == ""
    @briefing_minute = params[:briefing_minute]
    params[:check_in] = " " if params[:check_in].strip == ""
    @check_in = params[:check_in]
    params[:check_out] = " " if params[:check_out].strip == ""
    @check_out = params[:check_out]
    params[:hour_closed1] = " " if params[:hour_closed1].strip == ""
    @hour_closed1 = params[:hour_closed1]
    params[:hour_closed2] = " " if params[:hour_closed2].strip == ""
    @hour_closed2 = params[:hour_closed2]
    params[:minute_closed1] = " " if params[:minute_closed1].strip == ""
    @minute_closed1 = params[:minute_closed1]
    params[:minute_closed2] = " " if params[:minute_closed2].strip == ""
    @minute_closed2 = params[:minute_closed2]
    @contact1 = Staff.find(params[:contact_officer_id].to_i)
    if params[:contact_officer_id2].strip == ""
      @contact2=" "
    else
      @contact2 = Staff.find(params[:contact_officer_id2].to_i)
    end

    @tempat_suaikenal = params[:tempat_suaikenal]

    @students = CourseApplication.find(params[:course_application_ids])
    #for student in @students
    #  gen_pdf_all_format_3(student, "#{student.id.to_s}.pdf")
    #end

    #gen_pdf_all_format_1(filename) if params[:format_surat].to_i == 1 or params[:format_surat].to_i == 3
    #gen_pdf_all_format_2(filename) if params[:format_surat].to_i == 2 or params[:format_surat].to_i == 4

    #redirect_to("/surat/" + filename)
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => filename,
               :page_size => 'A4'
      end
    end
  end


  def cetak_pemohon_semua

    if params[:type] == "all"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = @course_applications
    end

    if params[:type] == "unprocessed"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND student_status_id=1", :order => "date_apply")
      #render_text @course_applications.size and return
    end

    if params[:type] == "accepted"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = @course_applications[0].course_implementation.selected_applicants

    end

    if params[:type] == "rejected"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND student_status_id=3", :order => "date_apply")
    end


    if params[:type] == "confirmed"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND (student_status_id=4 or student_status_id=5 or student_status_id=6 or student_status_id=8 or student_status_id=9)", :order => "date_apply")
    end

    if params[:type] == "confirmednot"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND student_status_id=7", :order => "date_apply")

    end

    if params[:type] == "norespon"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND student_status_id=2", :order => "date_apply")

    end

    if params[:type] == "hadir"
      #render_text params[:type] + ">>" + params[:id] 
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND (student_status_id=5 or student_status_id=8 or student_status_id=9)", :order => "date_apply")

    end

    if params[:type] == "takhadir"
      #render_text params[:type] + ">>" + params[:id]
      @course_applications = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{params[:id]} AND (student_status_id=4 or student_status_id=6)", :order => "date_apply")
    end

    require "prawn"
    require "prawn/measurement_extensions"

    pdf = Prawn::Document.new(:page_size => "A4", :margin => [5.mm])
    pdf.font "Helvetica"
    pdf.font_size 8
    @my_margin = pdf.bounds.absolute_top

    total = @students.size
    i = 1

    for @course_application in @students
      @relative = Relative.find_by_profile_id(@course_application.profile_id)
      @employment = Employment.find_by_profile_id(@course_application.profile_id)
      @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
      @student = Profile.find_by_id(@course_application.profile_id)

      pdf.fill_color "000000"

      h = 5.mm
      pdf.margins 20.mm
      pdf.move_cursor_to 10.mm

      pdf.text "<b>Institut Tanah dan Ukur Negara (INSTUN)</b>", :align => :center, :size => 10, :inline_format => true
      pdf.text "<b>Sistem Pengurusan Kursus (eSPEK)</b>", :align => :center, :size => 10, :inline_format => true
      pdf.text " \n"
      pdf.text "<b>Maklumat Peserta Kursus</b>", :align => :center, :size => 8, :inline_format => true
      pdf.move_cursor_to h

      pdf.text "<b>Kursus \t:\t</b>"+@course_application.course_implementation.code + "\t(" +@course_application.course.name + ")", :align => :center, :character_spacing => 1, :inline_format => true

      pdf.move_cursor_to h
      y_coor = pdf.y
      x_coor_init = pdf.bounds.absolute_left

      pdf.fill_color "808080"
      y_coor = pdf.y - 15
      pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor)

      pdf.fill_color "000000"
      pdf.move_cursor_to h+10

      pdf.text "<b>Maklumat Peribadi</b>", :align => :center, :inline_format => true

      pdf.text "<b>NO KP</b>", :inline_format => true
      pdf.draw_text "<b>:</b>", :at => [150, pdf.y]
      y_coor = pdf.y
      pdf.draw_text(nof { @course_application.profile.ic_number }, :at => [160, pdf.y])

      pdf.draw_text("<b>Gelaran</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(nof { @student.title.description }, :at => [430, y_coor])

      pdf.text("<b>Nama</b>", :align => :left)
      pdf.draw_text("<b>:</b>", :at => [150, pdf.y])
      y_coor = pdf.y
      pdf.draw_text(nof { @student.name }, :at => [160, pdf.y])

      pdf.draw_text("<b>Jantina</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(nof { @student.gender.description }, :at => [430, y_coor])

      pdf.text("<b>Tarikh Lahir</b>", :align => :left)
      pdf.draw_text("<b>:</b>", :at => [150, pdf.y])
      y_coor = pdf.y
      pdf.draw_text(nof { @student.date_of_birth.to_formatted_s(:my_format_4) }, :at => [160, pdf.y])

      pdf.draw_text("<b>Agama</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(nof { @student.religion.description }, :at => [430, y_coor])

      pdf.text("<b>Keturunan</b>", :align => :left)
      pdf.draw_text("<b>:</b>", :at => [150, pdf.y])
      y_coor = pdf.y
      pdf.draw_text(nof { @student.race.description }, :at => [160, pdf.y])

      pdf.draw_text("<b>Taraf Perkahwinan</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(nof { @student.marital_status.description }, :at => [430, y_coor])

      pdf.text("<b>Kecacatan</b>", :align => :left)
      pdf.draw_text("<b>:</b>", :at => [150, pdf.y])
      y_coor = pdf.y
      pdf.draw_text(nof { @student.handicap.description }, :at => [160, pdf.y])

      a = ["TIDAK", "YA"]

      pdf.draw_text("<b>Vegetarian</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(a[nof { @student.is_vegetarian }], :at => [430, y_coor])

      pdf.text("<b>No. Tel. Bimbit</b>", :align => :left)
      pdf.draw_text("<b>:</b>", :at => [150, pdf.y])
      y_coor = pdf.y
      pdf.draw_text(nof { @student.mobile }, :at => [160, pdf.y])

      pdf.draw_text("<b>Email Rasmi</b>", :at => [350, y_coor])
      pdf.draw_text("<b>:</b>", :at => [420, y_coor])
      pdf.draw_text(nof { @student.email }, :at => [430, y_coor])

      pdf.fill_color "808080"
      y_coor = pdf.y-15
      pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor)

      ## END MAKLUMAT PEMOHON B
      #pdf.fill_color Color::RGB::Black
      #pdf.move_pointer(h+10)
      #
      #pdf.text("<b>Maklumat Waris</b>", :justification => :center)
      #pdf.move_pointer(h)
      #y_coor = pdf.y
      #
      #pdf.text("<b>Nama</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @relative.name })
      #
      #pdf.add_text(350, y_coor, "<b>Hubungan</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, nof { @relative.relationship.description })
      #
      #pdf.text("<b>Alamat</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @relative.address1 })
      #pdf.text(" \n")
      #y_coor = pdf.y
      #pdf.add_text(160, y_coor, nof { @relative.address2 })
      #pdf.text(" \n")
      #y_coor = pdf.y
      #pdf.add_text(160, y_coor, nof { @relative.address3 })
      #pdf.text(" \n")
      #y_coor = pdf.y
      #pdf.add_text(160, y_coor, nof { @relative.state.description })
      #
      #pdf.text("<b>No Tel. Rumah</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @relative.phone })
      #
      #pdf.add_text(350, y_coor, "<b>No Tel. Bimbit</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, nof { @relative.mobile })
      #
      #pdf.fill_color Color::RGB::Grey
      #y_coor = pdf.y-15
      #pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
      ####ENDMAKLUMAT WARIS
      #pdf.fill_color Color::RGB::Black
      #if nof { @employment.place }
      #  if @employment.place.place_type_id == 3
      #    @shou = nof { @employment.place.name }
      #    @kenchou = ""
      #    @jimusho = ""
      #  end
      #  if @employment.place.place_type_id == 1
      #    @kenchou = nof { @employment.place.name }
      #    @shou = nof { @employment.place.parent.name }
      #    @jimusho = ""
      #  end
      #  if @employment.place.place_type_id == 2
      #    @jimusho = nof { @employment.place.name }
      #    @kenchou = nof { @employment.place.parent.name }
      #    @shou = nof { @employment.place.parent.parent.name }
      #  end
      #end
      #
      #pdf.move_pointer(h+10)
      #pdf.text("<b>Maklumat Perkhidmatan</b>", :justification => :center)
      #pdf.move_pointer(h)
      #
      #pdf.text("<b>Kementerian</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @shou })
      #
      #pdf.add_text(350, y_coor, "<b>Jabatan</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, nof { @kenchou })
      #
      #pdf.text("<b>Pejabat</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @jimusho })
      #
      #pdf.add_text(350, y_coor, "<b>Jawatan/Gred</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, "#{nof { @employment.job_profile.job_name }} / #{nof { @employment.job_profile.job_grade }}")
      #
      #pdf.text("<b>Gelaran Jawatan</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @student.designation })
      #
      #pdf.fill_color Color::RGB::Grey
      #y_coor = pdf.y-15
      #pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
      #
      #pdf.fill_color Color::RGB::Black
      #
      #pdf.move_pointer(h+10)
      #pdf.text("<b>Maklumat Tempat Bertugas</b>", :justification => :center)
      #pdf.move_pointer(h)
      #
      #pdf.text("<b>Gelaran Ketua Pejabat</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @student.hod })
      #
      #pdf.text("<b>Nama Pejabat</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @student.opis })
      #
      #pdf.text("<b>Alamat</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @student.address1 })
      #pdf.text(" \n")
      #y_coor = pdf.y
      #pdf.add_text(160, y_coor, nof { @student.address2 })
      #pdf.text(" \n")
      #y_coor = pdf.y
      #pdf.add_text(160, y_coor, nof { @student.address3 })
      #
      #pdf.text("<b>No. Tel</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @student.phone })
      #
      #pdf.add_text(350, y_coor, "<b>No. Fax</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, nof { @student.fax })
      #
      #pdf.text(" \n")
      #pdf.text("<b>Pegawai yang Meluluskan Permohonan</b>", :justification => :left)
      #pdf.text("<b>Nama</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #pdf.add_text(160, pdf.y, nof { @course_application.supervisor_name })
      #
      #pdf.text("<b>Jawatan</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, nof { @course_application.supervisor_jawatan })
      #
      #pdf.add_text(350, y_coor, "<b>Email</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, nof { @course_application.supervisor_email })
      #
      #pdf.text(" \n")
      #pdf.text("<b>Perakuan:\nSetelah disemak, saya mengaku maklumat diatas adalah betul</b>", :justification => :left)
      #
      #pdf.text("<b>Tandatangan</b>", :justification => :left)
      #pdf.add_text(150, pdf.y, "<b>:</b>")
      #y_coor = pdf.y
      #pdf.add_text(160, pdf.y, "")
      #
      #pdf.add_text(350, y_coor, "<b>Tarikh</b>")
      #pdf.add_text(420, y_coor, "<b>:</b>")
      #pdf.add_text(430, y_coor, "")
      #
      #pdf.fill_color Color::RGB::Grey
      #y_coor = pdf.y-15
      #pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
      #
      #pdf.fill_color Color::RGB::Black

      pdf.start_new_page if i < total
      i = i+1

      pdf.y = @my_margin

    end # for student all








    #pdf = PDF::Writer.new(:paper => "A4")
    #pdf.select_font("Helvetica")
    #pdf.font_size=8
    #pdf.margins_mm(20)
    #bi = "i" # font detail style bold or italic bold= b , italic = i
    #@my_margin = pdf.absolute_top_margin
    #
    #total = @students.size
    #i = 1
    #
    ##if RUBY_PLATFORM == "i386-mswin32"
    ##	espek_header_image = "public/images/espek-header.jpg"
    ##else
    ##  	espek_header_image = "/aplikasi/www/instun/public/images/espek-header.jpg"
    ##end
    #
    #for @course_application in @students
    #  @relative = Relative.find_by_profile_id(@course_application.profile_id)
    #  @employment = Employment.find_by_profile_id(@course_application.profile_id)
    #  @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
    #  @student = Profile.find_by_id(@course_application.profile_id)
    #
    #  pdf.fill_color Color::RGB::Black
    #  h = pdf.mm2pts(5)
    #  pdf.margins_mm(20)
    #
    #  #pdf.image(espek_header_image)
    #  pdf.move_pointer(pdf.mm2pts(10))
    #  pdf.text("<b>Institut Tanah dan Ukur Negara (INSTUN)</b>", :justification => :center, :font_size => 10)
    #  pdf.text("<b>Sistem Pengurusan Kursus (eSPEK)</b>", :justification => :center, :font_size => 10)
    #  pdf.text(" \n")
    #  pdf.text("<b>Maklumat Peserta Kursus</b>", :justification => :center, :font_size => 8)
    #  pdf.move_pointer(h)
    #
    #  pdf.text("<b>Kursus \t:\t</b>"+@course_application.course_implementation.code + "\t(" +@course_application.course.name + ")", :justification => :center, :spacing => 1)
    #  pdf.move_pointer(h)
    #  y_coor = pdf.y
    #  x_coor_init = pdf.absolute_left_margin
    #
    #  pdf.fill_color Color::RGB::Grey
    #  y_coor = pdf.y-15
    #  pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    #
    #  pdf.fill_color Color::RGB::Black
    #  pdf.move_pointer(h+10)
    #
    #  pdf.text("<b>Maklumat Peribadi</b>", :justification => :center)
    #
    #  pdf.text("<b>NO KP</b>")
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @course_application.profile.ic_number })
    #
    #  pdf.add_text(350, y_coor, "<b>Gelaran</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.title.description })
    #
    #  pdf.text("<b>Nama</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.name })
    #
    #  pdf.add_text(350, y_coor, "<b>Jantina</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.gender.description })
    #
    #  pdf.text("<b>Tarikh Lahir</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.date_of_birth.to_formatted_s(:my_format_4) })
    #
    #  pdf.add_text(350, y_coor, "<b>Agama</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.religion.description })
    #
    #  pdf.text("<b>Keturunan</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.race.description })
    #
    #  pdf.add_text(350, y_coor, "<b>Taraf Perkahwinan</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.marital_status.description })
    #
    #  pdf.text("<b>Kecacatan</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.handicap.description })
    #
    #  a = ["TIDAK", "YA"]
    #
    #  pdf.add_text(350, y_coor, "<b>Vegetarian</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, a[nof { @student.is_vegetarian }])
    #
    #  pdf.text("<b>No. Tel. Bimbit</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.mobile })
    #
    #  pdf.add_text(350, y_coor, "<b>Email Rasmi</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.email })
    #
    #  pdf.fill_color Color::RGB::Grey
    #  y_coor = pdf.y-15
    #  pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    #
    #  ## END MAKLUMAT PEMOHON B
    #  pdf.fill_color Color::RGB::Black
    #  pdf.move_pointer(h+10)
    #
    #  pdf.text("<b>Maklumat Waris</b>", :justification => :center)
    #  pdf.move_pointer(h)
    #  y_coor = pdf.y
    #
    #  pdf.text("<b>Nama</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @relative.name })
    #
    #  pdf.add_text(350, y_coor, "<b>Hubungan</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @relative.relationship.description })
    #
    #  pdf.text("<b>Alamat</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @relative.address1 })
    #  pdf.text(" \n")
    #  y_coor = pdf.y
    #  pdf.add_text(160, y_coor, nof { @relative.address2 })
    #  pdf.text(" \n")
    #  y_coor = pdf.y
    #  pdf.add_text(160, y_coor, nof { @relative.address3 })
    #  pdf.text(" \n")
    #  y_coor = pdf.y
    #  pdf.add_text(160, y_coor, nof { @relative.state.description })
    #
    #  pdf.text("<b>No Tel. Rumah</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @relative.phone })
    #
    #  pdf.add_text(350, y_coor, "<b>No Tel. Bimbit</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @relative.mobile })
    #
    #  pdf.fill_color Color::RGB::Grey
    #  y_coor = pdf.y-15
    #  pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    #  ###ENDMAKLUMAT WARIS
    #  pdf.fill_color Color::RGB::Black
    #  if nof { @employment.place }
    #    if @employment.place.place_type_id == 3
    #      @shou = nof { @employment.place.name }
    #      @kenchou = ""
    #      @jimusho = ""
    #    end
    #    if @employment.place.place_type_id == 1
    #      @kenchou = nof { @employment.place.name }
    #      @shou = nof { @employment.place.parent.name }
    #      @jimusho = ""
    #    end
    #    if @employment.place.place_type_id == 2
    #      @jimusho = nof { @employment.place.name }
    #      @kenchou = nof { @employment.place.parent.name }
    #      @shou = nof { @employment.place.parent.parent.name }
    #    end
    #  end
    #
    #  pdf.move_pointer(h+10)
    #  pdf.text("<b>Maklumat Perkhidmatan</b>", :justification => :center)
    #  pdf.move_pointer(h)
    #
    #  pdf.text("<b>Kementerian</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @shou })
    #
    #  pdf.add_text(350, y_coor, "<b>Jabatan</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @kenchou })
    #
    #  pdf.text("<b>Pejabat</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @jimusho })
    #
    #  pdf.add_text(350, y_coor, "<b>Jawatan/Gred</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, "#{nof { @employment.job_profile.job_name }} / #{nof { @employment.job_profile.job_grade }}")
    #
    #  pdf.text("<b>Gelaran Jawatan</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @student.designation })
    #
    #  pdf.fill_color Color::RGB::Grey
    #  y_coor = pdf.y-15
    #  pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    #
    #  pdf.fill_color Color::RGB::Black
    #
    #  pdf.move_pointer(h+10)
    #  pdf.text("<b>Maklumat Tempat Bertugas</b>", :justification => :center)
    #  pdf.move_pointer(h)
    #
    #  pdf.text("<b>Gelaran Ketua Pejabat</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @student.hod })
    #
    #  pdf.text("<b>Nama Pejabat</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @student.opis })
    #
    #  pdf.text("<b>Alamat</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @student.address1 })
    #  pdf.text(" \n")
    #  y_coor = pdf.y
    #  pdf.add_text(160, y_coor, nof { @student.address2 })
    #  pdf.text(" \n")
    #  y_coor = pdf.y
    #  pdf.add_text(160, y_coor, nof { @student.address3 })
    #
    #  pdf.text("<b>No. Tel</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @student.phone })
    #
    #  pdf.add_text(350, y_coor, "<b>No. Fax</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @student.fax })
    #
    #  pdf.text(" \n")
    #  pdf.text("<b>Pegawai yang Meluluskan Permohonan</b>", :justification => :left)
    #  pdf.text("<b>Nama</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  pdf.add_text(160, pdf.y, nof { @course_application.supervisor_name })
    #
    #  pdf.text("<b>Jawatan</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, nof { @course_application.supervisor_jawatan })
    #
    #  pdf.add_text(350, y_coor, "<b>Email</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, nof { @course_application.supervisor_email })
    #
    #  pdf.text(" \n")
    #  pdf.text("<b>Perakuan:\nSetelah disemak, saya mengaku maklumat diatas adalah betul</b>", :justification => :left)
    #
    #  pdf.text("<b>Tandatangan</b>", :justification => :left)
    #  pdf.add_text(150, pdf.y, "<b>:</b>")
    #  y_coor = pdf.y
    #  pdf.add_text(160, pdf.y, "")
    #
    #  pdf.add_text(350, y_coor, "<b>Tarikh</b>")
    #  pdf.add_text(420, y_coor, "<b>:</b>")
    #  pdf.add_text(430, y_coor, "")
    #
    #  pdf.fill_color Color::RGB::Grey
    #  y_coor = pdf.y-15
    #  pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    #
    #  pdf.fill_color Color::RGB::Black
    #
    #  pdf.new_page if i < total
    #  i = i+1
    #
    #  pdf.y = @my_margin
    #
    #end # for student all

    #file = @course_application.course_implementation.code.sub(/\//, "_") + "_" + params[:type] +".pdf"
    #if RUBY_PLATFORM == "i386-mswin32"
    #  pdf.save_as("public/maklumat_pemohon/" + file) #kat windows
    #else
    #  pdf.save_as("/aplikasi/www/instun/public/maklumat_pemohon/" + file) #kalu kat bsd
    #end

    pdf.render_file(file)

    redirect_to("/maklumat_pemohon/"+file)
  end

  def cetak_pemohon
#    require "pdf/writer"

    @course_application = CourseApplication.find(params[:id])
    @student = @course_application
    @relative = Relative.find_by_profile_id(@course_application.profile_id)
    @employment = Employment.find_by_profile_id(@course_application.profile_id)
    @qualification =Qualification.find_by_profile_id(@course_application.profile_id)

    cetak_pemohon_template(params[:id])

    file = "pemohon_" + params[:id] + ".pdf"
    redirect_to("/maklumat_pemohon/"+file)
  end

  private
  def cetak_pemohon_template(id)

    pdf = PDF::Writer.new(:paper => "A4")
    pdf.select_font("Helvetica")
    pdf.font_size=8
    pdf.margins_mm(20)
    bi = "i" # font detail style bold or italic bold= b , italic = i 

    #if RUBY_PLATFORM == "i386-mswin32"
    #	espek_header_image = "public/images/espek-header.jpg"
    #else
    #	espek_header_image = "/aplikasi/www/instun/public/images/espek-header.jpg"
    #end	

    #pdf.image(espek_header_image)
    pdf.stroke_color Color::RGB::Red

    h = pdf.mm2pts(5)
    pdf.move_pointer(pdf.mm2pts(10))
    pdf.text("<b>Institut Tanah dan Ukur Negara (INSTUN)</b>", :justification => :center, :font_size => 10)
    pdf.text("<b>Sistem Pengurusan Kursus (eSPEK)</b>", :justification => :center, :font_size => 10)
    pdf.text(" \n")
    pdf.text("<b>Maklumat Peserta Kursus</b>", :justification => :center, :font_size => 8)
    pdf.move_pointer(h)

    pdf.text("<b>Kursus \t:\t</b>"+@course_application.course_implementation.code + "\t(" +@course_application.course.name + ")", :justification => :center, :spacing => 1)
    pdf.text("<b>Tarikh Kursus \t:\t</b>"+@course_application.course_implementation.tempoh, :justification => :center, :spacing => 1)
    pdf.move_pointer(h)
    y_coor = pdf.y
    x_coor_init = pdf.absolute_left_margin

    pdf.fill_color Color::RGB::Grey
    y_coor = pdf.y-15
    pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill

    pdf.fill_color Color::RGB::Black
    pdf.move_pointer(h+10)

    pdf.text("<b>Maklumat Peribadi</b>", :justification => :center)

    pdf.text("<b>NO KP</b>")
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @course_application.profile.ic_number })

    pdf.add_text(350, y_coor, "<b>Gelaran</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.title.description })

    pdf.text("<b>Nama</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.name })

    pdf.add_text(350, y_coor, "<b>Jantina</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.gender.description })

    pdf.text("<b>Tarikh Lahir</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.date_of_birth.to_formatted_s(:my_format_4) })

    pdf.add_text(350, y_coor, "<b>Agama</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.religion.description })

    pdf.text("<b>Keturunan</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.race.description })

    pdf.add_text(350, y_coor, "<b>Taraf Perkahwinan</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.marital_status.description })

    pdf.text("<b>Kecacatan</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.handicap.description })

    a = ["Tidak", "Ya"]

    pdf.add_text(350, y_coor, "<b>Vegetarian</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, a[nof { @student.profile.is_vegetarian }])

    pdf.text("<b>No. Tel. Bimbit</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.mobile })

    pdf.add_text(350, y_coor, "<b>Email Rasmi</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.email })

    pdf.fill_color Color::RGB::Grey
    y_coor = pdf.y-15
    pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill

    ## END MAKLUMAT PEMOHON B
    pdf.fill_color Color::RGB::Black
    pdf.move_pointer(h+10)

    pdf.text("<b>Maklumat Waris</b>", :justification => :center)
    pdf.move_pointer(h)
    y_coor = pdf.y

    pdf.text("<b>Nama</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @relative.name })

    pdf.add_text(350, y_coor, "<b>Hubungan</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @relative.relationship.description })

    pdf.text("<b>Alamat</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @relative.address1 })
    pdf.text(" \n")
    y_coor = pdf.y
    pdf.add_text(160, y_coor, nof { @relative.address2 })
    pdf.text(" \n")
    y_coor = pdf.y
    pdf.add_text(160, y_coor, nof { @relative.address3 })
    pdf.text(" \n")
    y_coor = pdf.y
    pdf.add_text(160, y_coor, nof { @relative.state.description })

    pdf.text("<b>No Tel. Rumah</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @relative.phone })

    pdf.add_text(350, y_coor, "<b>No Tel. Bimbit</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @relative.mobile })

    pdf.fill_color Color::RGB::Grey
    y_coor = pdf.y-15
    pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill
    ###ENDMAKLUMAT WARIS
    pdf.fill_color Color::RGB::Black
    if nof { @employment.place }
      if @employment.place.place_type_id == 3
        @shou = nof { @employment.place.name }
        @kenchou = ""
        @jimusho = ""
      end
      if @employment.place.place_type_id == 1
        @kenchou = nof { @employment.place.name }
        @shou = nof { @employment.place.parent.name }
        @jimusho = ""
      end
      if @employment.place.place_type_id == 2
        @jimusho = nof { @employment.place.name }
        @kenchou = nof { @employment.place.parent.name }
        @shou = nof { @employment.place.parent.parent.name }
      end
    end

    pdf.move_pointer(h+10)
    pdf.text("<b>Maklumat Perkhidmatan</b>", :justification => :center)
    pdf.move_pointer(h)

    pdf.text("<b>Kementerian</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @shou })

    pdf.add_text(350, y_coor, "<b>Jabatan</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @kenchou })

    pdf.text("<b>Pejabat</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @jimusho })

    pdf.add_text(350, y_coor, "<b>Jawatan/Gred</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @employment.job_profile.job_name } + "/" + nof { @employment.job_profile.job_grade })

    pdf.text("<b>Gelaran Jawatan</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @student.profile.designation })

    pdf.fill_color Color::RGB::Grey
    y_coor = pdf.y-15
    pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill

    pdf.fill_color Color::RGB::Black

    pdf.move_pointer(h+10)
    pdf.text("<b>Maklumat Tempat Bertugas</b>", :justification => :center)
    pdf.move_pointer(h)

    pdf.text("<b>Gelaran Ketua Pejabat</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @student.profile.hod })

    pdf.text("<b>Nama Pejabat</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @student.profile.opis })

    pdf.text("<b>Alamat</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @student.profile.address1 })
    pdf.text(" \n")
    y_coor = pdf.y
    pdf.add_text(160, y_coor, nof { @student.profile.address2 })
    pdf.text(" \n")
    y_coor = pdf.y
    pdf.add_text(160, y_coor, nof { @student.profile.address3 })

    pdf.text("<b>No. Tel</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @student.profile.phone })

    pdf.add_text(350, y_coor, "<b>No. Fax</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @student.profile.fax })

    pdf.text(" \n")
    pdf.text("<b>Pegawai yang Meluluskan Kehadiran Kursus</b>", :justification => :left)
    pdf.text("<b>Nama</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    pdf.add_text(160, pdf.y, nof { @course_application.supervisor_name })

    pdf.text("<b>Jawatan</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, nof { @course_application.supervisor_jawatan })

    pdf.add_text(350, y_coor, "<b>Email</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, nof { @course_application.supervisor_email })

    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text("<b>Perakuan:\nSetelah disemak, saya mengaku maklumat diatas adalah betul</b>", :justification => :left)

    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text("<b>Tandatangan</b>", :justification => :left)
    pdf.add_text(150, pdf.y, "<b>:____________________________</b>")
    y_coor = pdf.y
    pdf.add_text(160, pdf.y, "")

    pdf.add_text(350, y_coor, "<b>Tarikh</b>")
    pdf.add_text(420, y_coor, "<b>:</b>")
    pdf.add_text(430, y_coor, "")

    pdf.fill_color Color::RGB::Grey
    y_coor = pdf.y-15
    pdf.line(x_coor_init, y_coor, pdf.absolute_right_margin, y_coor).fill

    pdf.fill_color Color::RGB::Black


    file = "pemohon_" + params[:id] + ".pdf"
    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/maklumat_pemohon/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/maklumat_pemohon/" + file) #kalu kat bsd
    end
    #redirect_to("/maklumat_pemohon/"+file)
  end

  ###Surat Tawaran format 1##################################################################
  def gen_pdf_all_format_1 (file)
    if RUBY_PLATFORM == "i386-mswin32"
      header_image = "public/images/header800.jpg"
      footer_image = "public/images/footer800.jpg"
    else
      header_image = "/aplikasi/www/instun/public/images/header800.jpg"
      footer_image = "/aplikasi/www/instun/public/images/footer800.jpg"
    end

    @font_size = 12
    @tajuk_font_size = 11

    pdf = PDF::Writer.new(:paper => "A4")
    if params[:format_surat].to_i == 3
      pdf.margins_pt(0, 50, 36, 50)
    else
      pdf.margins_pt(36, 50, 36, 50)
    end

    #pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
    @my_margin = pdf.absolute_top_margin - 30
    pdf.select_font("Helvetica")

    i = 1
    @students = CourseApplication.find(params[:course_application_ids])
    for student in @students
      if params[:format_surat].to_i == 3
        #pdf.image "/aplikasi/www/instun/public/images/header.jpg", :justification => :center
        pdf.add_image_from_file(header_image, 0, 730, 600, nil)
      end

      pdf.text "", :font_size => @font_size, :justification => :left

      @rujukan_kami = params[:rujukan_kami]
      @tarikh_surat_day = params[:tarikh_surat_day]
      @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
      @tarikh_surat_month = params[:tarikh_surat_month]
      @tarikh_surat_year = params[:tarikh_surat_year]

      tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
      @tarikh = msian_date_very_formal(tarikh_surat)
      @perkara = params[:surat_tawaran_content][:perkara]
      @perenggan1 = params[:surat_tawaran_content][:perenggan1]
      @perenggan2 = params[:surat_tawaran_content][:perenggan2]
      @perenggan3 = params[:surat_tawaran_content][:perenggan3]
      @perenggan4 = params[:surat_tawaran_content][:perenggan4]
      @perenggan5 = params[:surat_tawaran_content][:perenggan5]
      salinan_kepada = params[:salinan_kepada]
      @signature = Signature.find_by_filename(params[:signature_file])
      if @signature
        @tandatangan_nama = @signature.person_name.upcase
        if @signature.person_position != ""
          @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
        else
          @tandatangan_jawatan = ""
        end
      else
        @tandatangan_nama = "                     "
        @tandatangan_jawatan = "                     "
      end

      employment = Employment.find_by_profile_id(student.profile.id)
      place = nof { employment.place }
      if place
        addr1 = nof { place.address1.split(" ").map! { |e| e }.join(" ") }
        addr2 = nof { place.address2.split(" ").map! { |e| e }.join(" ") }
        addr3 = nof { place.address3.split(" ").map! { |e| e }.join(" ") }
        addr4 = nof { place.address4.split(" ").map! { |e| e }.join(" ") }
        state = nof { place.state.description.split(" ").map! { |e| e.capitalize }.join(" ") }

        addr_arr = Array.new
        addr_arr.push(place.name.upcase) if place.name != ""
        addr_arr.push(addr1) if place.address1 != ""
        addr_arr.push(addr2) if place.address2 != ""
        addr_arr.push(addr3) if place.address3 != ""
        addr_arr.push(addr4) if place.address4 != ""
        addr_arr.push(state.upcase) if place.state !=nil
        company_addr = addr_arr.join("\n")
        company_addr = company_addr.tr_s(',', ',')
      else
        addr_arr = Array.new
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        company_addr = addr_arr.join(" \n")
        company_addr = company_addr.tr_s(',', ',')
      end

      if (student.profile.address1 != nil) && (student.profile.state != nil)
        p_addr1 = student.profile.address1.split(" ").map! { |e| e }.join(" ")
        p_addr2 = student.profile.address2.split(" ").map! { |e| e }.join(" ")
        p_addr3 = student.profile.address3.split(" ").map! { |e| e }.join(" ")
        p_state = student.profile.state.description.split(" ").map! { |e| e.capitalize }.join(" ")

        p_addr_arr = Array.new
        #p_addr_arr.push(student.profile.name.upcase) if student.profile.name != ""
        p_addr_arr.push(p_addr1) if student.profile.address1 != ""
        p_addr_arr.push(p_addr2) if student.profile.address2 != ""
        p_addr_arr.push(p_addr3) if student.profile.address3 != ""
        p_addr_arr.push(p_state.upcase) if student.profile.state != ""
        p_addr = p_addr_arr.join("\n")
        p_addr = p_addr.tr_s(',', ',')
      else
        p_addr_arr = Array.new
        #p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr = p_addr_arr.join(" \n")
      end


      #tandatangan_jawatan = params[:surat_tawaran_content][:tandatangan_jawatan].split(" ").map! {|e| e.capitalize}.join(" ")

      ketua = "#{student.profile.hod}"
      p_alamat = "#{p_addr}"
      alamat = "#{company_addr}"
      office_name = "#{student.profile.opis}"

      @alamat_instun = "\nPengarah," +
          "\nInstitut Tanah dan Ukur Negara(INSTUN)" +
          "\nKementerian Sumber Asli dan Alam Sekitar(NRE)" +
          "\nBehrang" +
          " 35950 Tanjung Malim" +
          "\nPerak Darul Ridzuan."

      #salinan_kepada = "Pengarah\n"+
      #                 "Institut Tanah dan Ukur Negara(INSTUN)\n\n" 

      if params[:format_surat].to_i == 3
        pdf.y = @my_margin -120
      else
        pdf.y = @my_margin -50
      end
      @rujukan_font_size = 10
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

      pdf.text "\n", :font_size => @font_size, :justification => :left
      student.profile.fax = "" if student.profile.fax == nil
      pdf.text "<b><c:uline>SEGERA DENGAN FAX #{student.profile.fax}</c:uline></b>\n", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "#{nof { student.profile.name }}\n", :font_size => @font_size, :justification => :left
      @ic_number = "#{student.profile.ic_number[0, 6]}-#{student.profile.ic_number[6, 2]}-#{student.profile.ic_number[8, 4]}"
      #pdf.text "<b>#{@ic_number}</b>\n", :font_size => @font_size, :justification => :left

      if employment and employment.job_profile
        job_name = nof { employment.job_profile.job_name }
        job_name = employment.job_profile.job_name.split(" ").map! { |e| e.capitalize }.join(" ") if @job_name != nil
        job_grade = nof { employment.job_profile.job_grade }
        @job_profile = "#{job_name}, #{job_grade}"
      else
        @job_profile = " "
      end

      pdf.text "#{@job_profile}", :font_size => @font_size, :justification => :left
      #pdf.text "<b>#{p_alamat}</b>", :font_size => @font_size, :justification => :left

      pdf.text "\nMelalui dan Salinan:", :font_size => @font_size, :justification => :left

      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "#{ketua}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "#{office_name}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "#{p_alamat}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :center
      pdf.text "Tuan/Puan,\n\n\n", :font_size => @font_size, :justification => :left
      @per_lines = @perkara.split("\n")
      for per_line in @per_lines
        pdf.text "<b>#{per_line}</b>", :font_size => @tajuk_font_size, :justification => :left
      end

      pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
      pdf.text "\n", :font_size => @font_size

      pdf.new_page
      pdf.y = @my_margin

      pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full
      pdf.text "\n\n", :font_size => @font_size, :justification => :center

      pdf.text "\n\nSekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'BERKHIDMAT UNTUK NEGARA'</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'MENDAHULUI CABARAN'</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'MS ISO 9001:2008 - PENGURUSAN LATIHAN'</b>\n\n", :font_size => @font_size, :justification => :left
      pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left
      if params[:is_cetakan_komputer].to_i == 0
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
      #pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left if params[:is_cetakan_komputer].to_i == 0
      if @tandatangan_nama != "SR HJ. ANUAR BIN HJ. SULAIMAN"
        pdf.text "\n<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
      end
      pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
      if @tandatangan_nama != "DATO' HAJI MOHD SHAFIE BIN ARIFIN"
        pdf.text "b.p Pengarah INSTUN", :font_size => @font_size, :justification => :left
      end
      pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @font_size, :justification => :left
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
      pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:is_cetakan_komputer].to_i==1

      pdf.new_page if i < @students.size
      i = i+1
      pdf.y = @my_margin


    end # @students loop

    pdf.new_page
    cetak_surat_sah_hadir(pdf)
    cetak_lampiran_c(pdf)

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end

  end

  #################################################################################
  def gen_pdf_all_format_2 (file)
    if RUBY_PLATFORM == "i386-mswin32"
      header_image = "public/images/header800.jpg"
      footer_image = "public/images/footer800.jpg"
    else
      header_image = "/aplikasi/www/instun/public/images/header800.jpg"
      footer_image = "/aplikasi/www/instun/public/images/footer800.jpg"
    end

    @font_size = 12
    @tajuk_font_size = 11

    pdf = PDF::Writer.new(:paper => "A4")
    if params[:format_surat].to_i == 4
      pdf.margins_pt(0, 50, 36, 50)
    else
      pdf.margins_pt(36, 50, 36, 50)
    end

    #pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
    @my_margin = pdf.absolute_top_margin - 30
    pdf.select_font("Helvetica")

    i = 1
    @students = CourseApplication.find(params[:course_application_ids])
    for student in @students
      if params[:format_surat].to_i == 4
        #pdf.image "/aplikasi/www/instun/public/images/header.jpg", :justification => :center
        pdf.add_image_from_file(header_image, 0, 730, 600, nil)
      end

      pdf.text "", :font_size => @font_size, :justification => :left

      @rujukan_kami = params[:rujukan_kami]
      @tarikh_surat_day = params[:tarikh_surat_day]
      @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
      @tarikh_surat_month = params[:tarikh_surat_month]
      @tarikh_surat_year = params[:tarikh_surat_year]

      tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
      @tarikh = msian_date_very_formal(tarikh_surat)
      @perkara = params[:surat_tawaran_content][:perkara]
      @perenggan1 = params[:surat_tawaran_content][:perenggan1]
      @perenggan2 = params[:surat_tawaran_content][:perenggan2]
      @perenggan3 = params[:surat_tawaran_content][:perenggan3]
      @perenggan4 = params[:surat_tawaran_content][:perenggan4]
      @perenggan5 = params[:surat_tawaran_content][:perenggan5]
      salinan_kepada = params[:salinan_kepada]
      @signature = Signature.find_by_filename(params[:signature_file])
      if @signature
        @tandatangan_nama = @signature.person_name.upcase
        if @signature.person_position != ""
          @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
        else
          @tandatangan_jawatan = ""
        end
      else
        @tandatangan_nama = "                     "
        @tandatangan_jawatan = "                     "
      end

      employment = Employment.find_by_profile_id(student.profile.id)
      place = nof { employment.place }
      if place
        addr1 = nof { place.address1.split(" ").map! { |e| e }.join(" ") }
        addr2 = nof { place.address2.split(" ").map! { |e| e }.join(" ") }
        addr3 = nof { place.address3.split(" ").map! { |e| e }.join(" ") }
        addr4 = nof { place.address4.split(" ").map! { |e| e }.join(" ") }
        state = nof { place.state.description.split(" ").map! { |e| e.capitalize }.join(" ") }

        addr_arr = Array.new
        addr_arr.push(place.name.upcase) if place.name != ""
        addr_arr.push(addr1) if place.address1 != ""
        addr_arr.push(addr2) if place.address2 != ""
        addr_arr.push(addr3) if place.address3 != ""
        addr_arr.push(addr4) if place.address4 != ""
        addr_arr.push(state.upcase) if place.state !=nil
        company_addr = addr_arr.join("\n")
        company_addr = company_addr.tr_s(',', ',')
      else
        addr_arr = Array.new
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        addr_arr.push(" ")
        company_addr = addr_arr.join(" \n")
        company_addr = company_addr.tr_s(',', ',')
      end

      if (student.profile.address1 != nil) && (student.profile.state != nil)
        p_addr1 = student.profile.address1.split(" ").map! { |e| e }.join(" ")
        p_addr2 = student.profile.address2.split(" ").map! { |e| e }.join(" ")
        p_addr3 = student.profile.address3.split(" ").map! { |e| e }.join(" ")
        p_state = student.profile.state.description.split(" ").map! { |e| e.capitalize }.join(" ")

        p_addr_arr = Array.new
        #p_addr_arr.push(student.profile.name.upcase) if student.profile.name != ""
        p_addr_arr.push(p_addr1) if student.profile.address1 != ""
        p_addr_arr.push(p_addr2) if student.profile.address2 != ""
        p_addr_arr.push(p_addr3) if student.profile.address3 != ""
        p_addr_arr.push(p_state.upcase) if student.profile.state != ""
        p_addr = p_addr_arr.join("\n")
        p_addr = p_addr.tr_s(',', ',')
      else
        p_addr_arr = Array.new
        #p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr = p_addr_arr.join(" \n")
      end


      #tandatangan_jawatan = params[:surat_tawaran_content][:tandatangan_jawatan].split(" ").map! {|e| e.capitalize}.join(" ")

      ketua = "#{student.profile.hod}"
      p_alamat = "#{p_addr}"
      alamat = "#{company_addr}"
      office_name = "#{student.profile.opis}"

      @alamat_instun = "\nPengarah," +
          "\nInstitut Tanah dan Ukur Negara(INSTUN)" +
          "\nKementerian Sumber Asli dan Alam Sekitar(NRE)" +
          "\nBehrang" +
          " 35950 Tanjung Malim" +
          "\nPerak Darul Ridzuan."

      #salinan_kepada = "Pengarah\n"+
      #                 "Institut Tanah dan Ukur Negara(INSTUN)\n\n" 


      if params[:format_surat].to_i == 4
        pdf.y = @my_margin -120
      else
        pdf.y = @my_margin -50
      end
      @rujukan_font_size = 10;
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

      pdf.text "\n", :font_size => @font_size, :justification => :left
      student.profile.fax = "" if student.profile.fax == nil
      pdf.text "<b><c:uline>SEGERA DENGAN FAX #{student.profile.fax}</c:uline></b>\n", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "#{nof { student.profile.name }}\n", :font_size => @font_size, :justification => :left
      @ic_number = "#{student.profile.ic_number[0, 6]}-#{student.profile.ic_number[6, 2]}-#{student.profile.ic_number[8, 4]}"
      #pdf.text "<b>#{@ic_number}</b>\n", :font_size => @font_size, :justification => :left

      @nama = student.profile.name
      @kp = student.profile.ic_number

      if employment and employment.job_profile
        job_name = nof { employment.job_profile.job_name }
        job_name = employment.job_profile.job_name.split(" ").map! { |e| e.capitalize }.join(" ") if @job_name != nil
        job_grade = nof { employment.job_profile.job_grade }
        @job_profile = "#{job_name}, #{job_grade}"
      else
        @job_profile = " "
      end

      pdf.text "#{@job_profile}", :font_size => @font_size, :justification => :left
      #pdf.text "<b>#{p_alamat}</b>", :font_size => @font_size, :justification => :left

      pdf.text "\nMelalui dan Salinan:", :font_size => @font_size, :justification => :left

      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "#{ketua}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "#{office_name}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "#{p_alamat}".upcase, :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :center
      pdf.text "Tuan/Puan,\n\n\n", :font_size => @font_size, :justification => :left
      @per_lines = @perkara.split("\n")
      for per_line in @per_lines
        pdf.text "<b>#{per_line}</b>", :font_size => @tajuk_font_size, :justification => :left
      end

      pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
      pdf.text "\n", :font_size => @font_size

      pdf.new_page
      pdf.y = @my_margin

      pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full
      pdf.text "\n\n", :font_size => @font_size, :justification => :center

      pdf.text "\n\nSekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'BERKHIDMAT UNTUK NEGARA'</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'MENDAHULUI CABARAN'</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'MS ISO 9001:2008 - PENGURUSAN LATIHAN'</b>\n\n", :font_size => @font_size, :justification => :left
      pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left
      if params[:is_cetakan_komputer].to_i == 0
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
      #pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left if params[:is_cetakan_komputer].to_i == 0
      if @tandatangan_nama != "SR HJ. ANUAR BIN HJ. SULAIMAN"
        pdf.text "\n<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
      end
      pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
      if @tandatangan_nama != "DATO' HAJI MOHD SHAFIE BIN ARIFIN"
        pdf.text "b.p Pengarah INSTUN", :font_size => @font_size, :justification => :left
      end
      pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @font_size, :justification => :left
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
      pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:is_cetakan_komputer].to_i==1

      pdf.new_page #if i < @students.size  
      i = i+1
      pdf.y = @my_margin

      cetak_surat_sah_hadir2(pdf)
      cetak_lampiran_c(pdf)
      pdf.new_page

    end # @students loop

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end
  end

  #################################################################################
  def cetak_lampiran_c(pdf)
    pdf.new_page
    pdf.y = @my_margin
    pdf.text "\n<b>LAMPIRAN B</b>", :font_size => @font_size, :justification => :left
    pdf.text "\n\n\nMAKLUMAT KURSUS #{params[:course_implementation_name]} (#{params[:course_implementation_code]})", :font_size => @font_size, :justification => :center
    #require 'pdf/simpletable'

    #*******Query data which do not exist here**********07/02/2007 by madz
    @courses = Course.find_by_sql("SELECT c.* FROM courses c, course_implementations ci where ci.course_id=c.id and ci.code ilike '#{params[:course_implementation_code]}' limit 1")
    @location_name = CourseLocation.find(@courses[0].course_location_id)
    @department_name = CourseDepartment.find(@courses[0].course_department_id)
    @reference_name = @courses[0].reference
    @reference_name = "-" if (@reference_name==nil or @reference_name.strip=="")
    #***************************************************

    pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n1.", @font_size)
    pdf.add_text(80, pdf.y, "TARIKH", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, params[:duration].titleize, @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n2.", @font_size)
    pdf.add_text(80, pdf.y, "TEMPAT", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, @location_name.description, @font_size) if @location_name.description !=nil
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    #pdf.add_text(230, pdf.y,"INSTUN, Behrang , Tanjong Malim, Perak.", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n3.", @font_size)
    pdf.add_text(80, pdf.y, "PENGANJUR", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, @department_name.description + " INSTUN", @font_size) if @department_name.description !=nil

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n4.", @font_size)
    pdf.add_text(80, pdf.y, "PENDAFTARAN", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, params[:check_in], @font_size) if params[:check_in]!=nil
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(80, pdf.y, "(CHECK-IN)", @font_size)
    pdf.add_text(230, pdf.y, "Jam : #{params[:check_in_hour]}.#{params[:check_in_minute]} hingga 6.30 petang", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "[Lobi Pendaftaran Pejabat Domestik, INSTUN ]", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n5.", @font_size)
    pdf.add_text(80, pdf.y, "SUAIKENAL DAN", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)

    #***********************************************************************************08/02/2007 by madz
    params[:briefing] = " " if params[:briefing].strip == ""
    params[:briefing_hour] = " " if params[:briefing_hour].strip == ""
    params[:briefing_minute] = " " if params[:briefing_minute].strip == ""
    params[:check_in] = " " if params[:check_in].strip == ""
    params[:check_out] = " " if params[:check_out].strip == ""
    #params[:contact_officer_id] = "" if params[:contact_officer_id].strip == ""
    params[:hour_closed1] = " " if params[:hour_closed1].strip == ""
    params[:hour_closed2] = " " if params[:hour_closed2].strip == ""
    params[:minute_closed1] = " " if params[:minute_closed1].strip == ""
    params[:minute_closed2] = " " if params[:minute_closed2].strip == ""
    @contact1 = Staff.find(params[:contact_officer_id].to_i)
    if params[:contact_officer_id2].strip == ""
      @contact2=" "
    else
      @contact2 = Staff.find(params[:contact_officer_id2].to_i)
    end
    #***********************************************************************************

    pdf.add_text(230, pdf.y, params[:briefing], @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(80, pdf.y, "TAKLIMAT KURSUS", @font_size)
    am_or_pm = "pagi"
    am_or_pm = "petang" if params[:briefing_hour].to_i > 12
    pdf.add_text(230, pdf.y, "Jam : #{params[:briefing_hour]}.#{params[:briefing_minute]} #{am_or_pm}", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "Tempat: #{params[:tempat_suaikenal]}", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n6.", @font_size)
    pdf.add_text(80, pdf.y, "PENGINAPAN", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    #pdf.add_text(230, pdf.y, "Dua orang sebilik akan disediakan", @font_size)
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "Disediakan di Asrama INSTUN", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n7.", @font_size)
    pdf.add_text(80, pdf.y, "MAKAN/MINUM", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, "Disediakan sepanjang kursus (bermula pada makan malam", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "pada #{params[:check_in]} hingga makan tengahari pada", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "#{params[:check_out]}).", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n8.", @font_size)
    pdf.add_text(80, pdf.y, "PAKAIAN/KEPERLUAN", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, "(a) Pakaian rasmi ke pejabat", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(80, pdf.y, "LAIN", @font_size)
    pdf.add_text(230, pdf.y, "(b) Lain-lain keperluan peribadi", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "(c) Pakaian dan kasut sukan", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "(d) Peralatan Sukan", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "    (raket badminton/tenis/ping pong)", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "(e) Tuala, sabun mandi, berus dan ubat gigi", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "(f ) Ubat- ubatan yang diperlukan", @font_size)

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n9.", @font_size)
    pdf.add_text(80, pdf.y, "BUKU RUJUKAN", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, "Sila bawa bersama buku rujukan berikut:", @font_size)
    pdf.text @reference_name, :font_size => @font_size, :left => 180

    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n10.", @font_size)
    pdf.add_text(80, pdf.y, "MAJLIS PENUTUP DAN ", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, params[:check_out], @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(80, pdf.y, "PENYAMPAIAN SIJIL", @font_size)
    pdf.add_text(230, pdf.y, "Jam : #{params[:hour_closed1]}.#{params[:minute_closed1]} hingga  #{params[:hour_closed2]}.#{params[:minute_closed2]} #{params[:timing_closed]}", @font_size)


    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n11.", @font_size)
    pdf.add_text(80, pdf.y, "CHECK-OUT", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, params[:check_out], @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, "Sebelum jam 5.00 petang", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n12.", @font_size)
    pdf.add_text(80, pdf.y, "URUSETIA", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, "1. #{@contact1.profile.name}", @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    if params[:contact_officer_id2].strip==""
      pdf.add_text(230, pdf.y, "2. #{@contact2}", @font_size)
    else
      pdf.add_text(230, pdf.y, "2. #{@contact2.profile.name}", @font_size)
    end

    @aktiviti1 = "Peserta juga dikehendaki mengikuti aktiviti luar seperti"
    @aktiviti2 = "Ceramah Agama/Sukan/Riadah/ Senamrobik di"
    @aktiviti3 = "mana aktiviti-aktiviti ini dimasukkkan ke dalam modul"
    @aktiviti4 = "untuk diambil kira bagi penilaian kursus."
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "\n13.", @font_size)
    pdf.add_text(80, pdf.y, "AKTIVITI LUAR", @font_size)
    pdf.add_text(210, pdf.y, ":", @font_size)
    pdf.add_text(230, pdf.y, @aktiviti1, @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, @aktiviti2, @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, @aktiviti3, @font_size)
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(230, pdf.y, @aktiviti4, @font_size)

    @passport = "Sila bawa bersama sekeping gambar berwarna berukuran passport"
    @tuntutan1 = "Peserta dikehendaki membayar yuran pendaftaran kursus"
    @tuntutan2 = "sebanyak RM30.00 dan boleh membuat tuntutan dengan"
    @tuntutan3 = "jabatan masing-masing. (Resit akan diberi untuk tujuan tuntutan)"
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    #pdf.add_text(pdf.left_margin, pdf.y, "\n14.", @font_size)
    #pdf.add_text(80, pdf.y, "LAIN-LAIN", @font_size)
    #pdf.add_text(210, pdf.y, ":", @font_size)
    #pdf.add_text(230, pdf.y, @passport, @font_size)		
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    #pdf.add_text(230, pdf.y, @tuntutan1, @font_size)
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    #pdf.add_text(230, pdf.y, @tuntutan2, @font_size)
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    #pdf.add_text(230, pdf.y, @tuntutan3, @font_size)

  end

  def cetak_surat_sah_hadir (pdf)
    @font_size = 11

    perkara = "<b>PENGESAHAN KEHADIRAN KURSUS #{params[:nama_kursus]} #{params[:tempoh]} DI INSTITUT TANAH DAN UKUR NEGARA (INSTUN)</b>"

    #pdf.y = pdf.top_margin - 100
    pdf.text "\n<b>LAMPIRAN A</b>", :font_size => @font_size, :justification => :left

    pdf.text "#{@alamat_instun}", :font_size => @font_size, :justification => :left
    pdf.text "<b>(u.p : #{params[:course_department]})</b>", :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.text "No Telefon : #{params[:penyelaras_telefon]} #{params[:penyelaras_ext]}\n", :font_size => @font_size, :justification => :left
    pdf.text "No Faks : #{params[:penyelaras_fax]}\n", :font_size => @font_size, :justification => :left
    pdf.text "E-mel : #{params[:penyelaras_email]}; #{params[:penyelaras_email2]}\n\n", :font_size => @font_size, :justification => :left if params[:penyelaras_email]!=""
    pdf.text "Tuan/Puan,", :font_size => @font_size, :justification => :left
    pdf.text "#{perkara}", :font_size => @font_size, :justification => :left
    pdf.text "\nMerujuk kepada perkara di atas, sukacita dimaklumkan bahawa saya ................................\n", :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.text "K/P:...............................\n", :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left

    pdf.rectangle(107, pdf.y-12, 8, 8).stroke
    pdf.rectangle(220, pdf.y-12, 8, 8).stroke
    pdf.rectangle(362, pdf.y-12, 8, 8).stroke
    pdf.text "                       HADIR                          TIDAK HADIR                        TIDAK HADIR", :font_size => @font_size, :justification => :left
    pdf.text "                                                                                                    (dengan PENGGANTI)", :font_size => @font_size, :justification => :left

    pdf.move_to(128, pdf.y-18).line_to(130, pdf.y-23).line_to(135, pdf.y-16)
    pdf.stroke

    pdf.text "\n<i>** Sila tandakan        pada yang  berkenaan</i>\n", :font_size => 10, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "TARIKH", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "_____________________", @font_size)
    pdf.text "\n==========================================================================", :font_size => @font_size, :justification => :left
    pdf.text "<b>Maklumat Pengganti (Diisi jika pegawai tidak hadir dengan pengganti)</b>", :font_size => 9, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NAMA", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NO. KP ", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "(jika ada)", :font_size => @font_size, :justification => :left
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "JAWATAN/GRED", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "ALAMAT JABATAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    #    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NO. TEL", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "NO. FAKS", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "______________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "EMEL", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "TARIKH", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "______________________", @font_size)

    pdf.text "\n==========================================================================", :font_size => @font_size, :justification => :left
    pdf.text "<b>(PENGESAHAN JABATAN)</b>", :font_size => 9, :justification => :left
    pdf.text "\nPegawai * <b>DIBENARKAN / TIDAK DIBENARKAN</b> mengikuti kursus di atas", :font_size => 9, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left

    #pdf.add_text(pdf.left_margin, pdf.y, "NAMA", @font_size)
    #pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NAMA/COP JABATAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    #    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TARIKH", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left


    #pdf.text "Sekian, terima kasih.", :font_size => 10, :justification => :left
    #pdf.text "<i>*   Sila kemukakan borang ini kepada Unit Pengurusan Latihan ICT pada atau sebelum #{params[:tarikh_tutup_kursus].upcase}</i>", :font_size => 10, :justification => :left

  end

  def cetak_surat_sah_hadir2 (pdf)
    @font_size = 11

    perkara = "<b>PENGESAHAN KEHADIRAN KURSUS #{params[:nama_kursus]} #{params[:tempoh]} DI INSTITUT TANAH DAN UKUR NEGARA (INSTUN)</b>"

    #pdf.y = pdf.top_margin - 100
    pdf.text "\n<b>LAMPIRAN A</b>", :font_size => @font_size, :justification => :left

    pdf.text "#{@alamat_instun}", :font_size => @font_size, :justification => :left
    pdf.text "<b>(u.p : #{params[:course_department]})</b>", :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.text "No Telefon : #{params[:penyelaras_telefon]} #{params[:penyelaras_ext]}\n", :font_size => @font_size, :justification => :left
    pdf.text "No Faks : #{params[:penyelaras_fax]}\n", :font_size => @font_size, :justification => :left
    pdf.text "E-mel : #{params[:penyelaras_email]}; #{params[:penyelaras_email2]}\n\n", :font_size => @font_size, :justification => :left if params[:penyelaras_email]!=""
    pdf.text "Tuan/Puan,", :font_size => @font_size, :justification => :left
    pdf.text "#{perkara}", :font_size => @font_size, :justification => :left
    pdf.text "\nMerujuk kepada perkara di atas, sukacita dimaklumkan bahawa saya <b>#{nof { @nama }}</b>  KP: <b>#{nof { @kp }}</b>\n\n", :font_size => @font_size, :justification => :left

    pdf.rectangle(107, pdf.y-12, 8, 8).stroke
    pdf.rectangle(220, pdf.y-12, 8, 8).stroke
    pdf.rectangle(362, pdf.y-12, 8, 8).stroke
    pdf.text "                       HADIR                          TIDAK HADIR                        TIDAK HADIR", :font_size => @font_size, :justification => :left
    pdf.text "                                                                                                    (dengan PENGGANTI)", :font_size => @font_size, :justification => :left

    pdf.move_to(128, pdf.y-8).line_to(130, pdf.y-13).line_to(135, pdf.y-6)
    pdf.stroke

    pdf.text "<i>** Sila tandakan        pada yang  berkenaan</i>\n\n", :font_size => 10, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "TARIKH", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "_____________________", @font_size)
    pdf.text "\n==========================================================================", :font_size => @font_size, :justification => :left
    pdf.text "<b>Maklumat Pengganti (Diisi jika pegawai tidak hadir dengan pengganti)</b>", :font_size => 9, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NAMA", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NO. KP ", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "(jika ada)", :font_size => @font_size, :justification => :left
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "JAWATAN/GRED", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "ALAMAT JABATAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n", :font_size => @font_size, :justification => :left
    #    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NO. TEL", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "NO. FAKS", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "______________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "EMEL", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.add_text(200, pdf.y, "_______________", @font_size)
    pdf.add_text(300, pdf.y, "TARIKH", @font_size)
    pdf.add_text(360, pdf.y, ":", @font_size)
    pdf.add_text(380, pdf.y, "______________________", @font_size)

    pdf.text "\n==========================================================================", :font_size => @font_size, :justification => :left
    pdf.text "<b>(PENGESAHAN JABATAN)</b>", :font_size => 9, :justification => :left
    pdf.text "\nPegawai * <b>DIBENARKAN / TIDAK DIBENARKAN</b> mengikuti kursus di atas", :font_size => 9, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left

    #pdf.add_text(pdf.left_margin, pdf.y, "NAMA", @font_size)
    #pdf.add_text(180, pdf.y, ":", @font_size)
    #pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TANDATANGAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "NAMA/COP JABATAN", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    #pdf.text "\n\n", :font_size => @font_size, :justification => :left
    #    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left
    pdf.add_text(pdf.left_margin, pdf.y, "TARIKH", @font_size)
    pdf.add_text(180, pdf.y, ":", @font_size)
    pdf.add_text(200, pdf.y, "___________________________________________________", @font_size)
    pdf.text "\n\n", :font_size => @font_size, :justification => :left


    #pdf.text "Sekian, terima kasih.", :font_size => 10, :justification => :left
    #pdf.text "<i>*   Sila kemukakan borang ini kepada Unit Pengurusan Latihan ICT pada atau sebelum #{params[:tarikh_tutup_kursus].upcase}</i>", :font_size => 10, :justification => :left

  end

  def gen_pdf_all_format_3 (student, file)
    @font_size = 12

    pdf = PDF::Writer.new(:paper => "A4")
    pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
    @my_margin = pdf.absolute_top_margin - 40
    pdf.select_font("Helvetica")

    i = 1
    pdf.text "", :font_size => @font_size, :justification => :left

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    @tarikh = params[:dateline]
    @perkara = params[:surat_tawaran_content][:perkara]
    @perenggan1 = params[:surat_tawaran_content][:perenggan1]
    @perenggan2 = params[:surat_tawaran_content][:perenggan2]
    @perenggan3 = params[:surat_tawaran_content][:perenggan3]
    @perenggan4 = params[:surat_tawaran_content][:perenggan4]
    @perenggan5 = params[:surat_tawaran_content][:perenggan5]
    @signature = Signature.find_by_filename(params[:signature_file])
    if @signature
      @tandatangan_nama = @signature.person_name.upcase
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "                     "
      @tandatangan_jawatan = "                     "
    end

    @nama = student.profile.name
    @kp = student.profile.ic_number

    employment = Employment.find_by_profile_id(student.profile.id)
    place = nof { employment.place }
    if place
      addr1 = nof { place.address1.split(" ").map! { |e| e }.join(" ") }
      addr2 = nof { place.address2.split(" ").map! { |e| e }.join(" ") }
      addr3 = nof { place.address3.split(" ").map! { |e| e }.join(" ") }
      addr4 = nof { place.address4.split(" ").map! { |e| e }.join(" ") }
      state = nof { place.state.description.split(" ").map! { |e| e }.join(" ") }

      addr_arr = Array.new
      addr_arr.push(place.name) if place.name != "" and place.name !=nil
      addr_arr.push(addr1) if place.address1 != ""
      addr_arr.push(addr2) if place.address2 != ""
      addr_arr.push(addr3) if place.address3 != ""
      addr_arr.push(addr4) if place.address4 != ""
      #addr_arr.push(state.upcase) if place.state != "" and place.state!=nil
      company_addr = addr_arr.join(",\n")
      company_addr = company_addr.tr_s(',', ',')
    else
      addr_arr = Array.new
      addr_arr.push(" ")
      addr_arr.push(" ")
      addr_arr.push(" ")
      addr_arr.push(" ")
      addr_arr.push(" ")
      company_addr = addr_arr.join(" \n")
      #company_addr = company_addr.tr_s(',' , ',')
    end

    if (student.profile.address1 != nil) && (student.profile.state != nil)
      p_addr1 = student.profile.address1.split(" ").map! { |e| e }.join(" ")
      p_addr2 = student.profile.address2.split(" ").map! { |e| e }.join(" ")
      p_addr3 = student.profile.address3.split(" ").map! { |e| e }.join(" ")
      p_state = student.profile.state.description.split(" ").map! { |e| e }.join(" ")

      p_addr_arr = Array.new
      #p_addr_arr.push(student.profile.name.upcase) if student.profile.name != "" and student.profile.name !=nil
      p_addr_arr.push(p_addr1) if student.profile.address1 != ""
      p_addr_arr.push(p_addr2) if student.profile.address2 != ""
      p_addr_arr.push(p_addr3) if student.profile.address3 != ""
      #p_addr_arr.push(p_state) if student.profile.state != "" and student.profile.state !=nil
      p_addr = p_addr_arr.join("\n")
      p_addr = p_addr.tr_s(',', ',')
    else
      p_addr_arr = Array.new
      #p_addr_arr.push(" ")
      p_addr_arr.push(" ")
      p_addr_arr.push(" ")
      p_addr_arr.push(" ")
      p_addr_arr.push(" ")
      p_addr = p_addr_arr.join(" \n")
    end

    ketua = "#{student.profile.hod}"
    office_name = "#{student.profile.opis}"
    p_alamat = "#{p_addr}."
    alamat = "#{company_addr}."

    @alamat_instun = "\nPengarah," +
        "\nInstitut Tanah dan Ukur Negara(INSTUN)" +
        "\nKementerian Sumber Asli dan Alam Sekitar(NRE)" +
        "\nBehrang" +
        " 35950 Tanjung Malim" +
        "\nPerak Darul Ridzuan."

    salinan_kepada = "Pengarah\n"+
        "Institut Tanah dan Ukur Negara(INSTUN)\n\n"
                                   #"Fail Timbul"


    pdf.y = @my_margin -50
    @rujukan_font_size = 10;
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

    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>#{nof { student.profile.name }}</b>\n", :font_size => @font_size, :justification => :left
    @ic_number = "#{student.profile.ic_number[0, 6]}-#{student.profile.ic_number[6, 2]}-#{student.profile.ic_number[8, 4]}"
                                   #pdf.text "<b>#{@ic_number}</b>\n", :font_size => @font_size, :justification => :left

    if employment and employment.job_profile
      job_name = nof { employment.job_profile.job_name }
      job_name = employment.job_profile.job_name.split(" ").map! { |e| e.capitalize }.join(" ") if @job_name != nil
      job_grade = nof { employment.job_profile.job_grade }
      @job_profile = "<b>#{job_name} Gred #{job_grade}</b>"
    else
      @job_profile = " "
    end
    pdf.text "#{@job_profile}", :font_size => @font_size, :justification => :left
                                   #pdf.text "<b>#{p_alamat}</b>", :font_size => @font_size, :justification => :left

    pdf.text "\nMelalui dan Salinan:", :font_size => @font_size, :justification => :left

    pdf.text "\n", :font_size => @font_size, :justification => :left
    pdf.text "#{ketua}", :font_size => @font_size, :justification => :left
    pdf.text "#{office_name}", :font_size => @font_size, :justification => :left
    pdf.text "#{p_alamat}", :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left

    pdf.text "\n\n\n", :font_size => @font_size, :justification => :center
    pdf.text "Tuan,\n\n", :font_size => @font_size, :justification => :left
    @per_lines = @perkara.split("\n")
    for per_line in @per_lines
      pdf.text "<b>#{per_line}</b>", :font_size => @font_size, :justification => :left
    end

    pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
    pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full
    pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
    pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
    pdf.text "\n", :font_size => @font_size

    pdf.new_page
    pdf.y = @my_margin

    pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full
    pdf.text "\n\n", :font_size => @font_size, :justification => :center

    pdf.text "\n\nSekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>`MENDAHULUI CABARAN`</b>\n", :font_size => @font_size, :justification => :left
    pdf.text "<b>`MS ISO 9001:2008 - PENGURUSAN LATIHAN`</b>\n\n", :font_size => @font_size, :justification => :left
    pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left
    if params[:is_cetakan_komputer].to_i == 0
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
                                   #pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left if params[:is_cetakan_komputer].to_i == 0
    pdf.text "<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
    pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
    pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @font_size, :justification => :left
    pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left

    #pdf.text "\n#{salinan_kepada}", :font_size => @font_size, :justification => :full
    #pdf.text "\ns.k", :font_size => @font_size, :justification => :left
    #sk_lines = salinan_kepada.split("\n")
    #for sk_line in sk_lines
    #pdf.add_text(80, pdf.y, "#{sk_line}", @font_size)
    #pdf.text "\n", :font_size => @font_size
    #end
    @nota_font_size = 9
    current_y = pdf.y
    pdf.y = pdf.absolute_bottom_margin - 20
    pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:is_cetakan_komputer].to_i==1

    #pdf.new_page
    cetak_surat_sah_hadir2(pdf)
    cetak_lampiran_c(pdf)

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    end

  end

  #####################RekodKursusPeserta(copy from user_applications)##########################################

  def history
    f = "student_status_id"
    s = Array.new
    s.push("#{f} = 3")
    s.push("#{f} = 6")
    s.push("#{f} = 8")
    s.push("#{f} = 9")
    t = s.join(" OR ")
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{session[:user].profile.id} AND (#{t})",
                                       :order => "date_apply DESC,student_status_id")
    @courses = Course.find(:all, :order => "name")
  end

  #################################################################################
  def init_load
    @states = State.find(:all, :order => "description")
    @genders = Gender.all
    @races = Race.find(:all, :order => "id")
    @handicaps = Handicap.find(:all, :order => "id")
    @profile_statuses = ProfileStatus.all
    @religions = Religion.find(:all, :order => "id")
    @countries = Country.all
    @marital_statuses = MaritalStatus.all
    @places = Place.find(:all, :order => "state_id")
    @relationships = Relationship.all
    @cert_levels = CertLevel.find(:all, :order => "id")
    @majors = Major.find(:all, :order => "id")
    @job_profiles = JobProfile.find(:all, :order => "job_grade")
    @titles = Title.find(:all, :order => "description")
    @course_departments = CourseDepartment.all
  end
end
