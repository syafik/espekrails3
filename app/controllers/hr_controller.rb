# -*- encoding : utf-8 -*-
class HrController < ApplicationController
	layout "standard-layout"
#  require "pdf/writer"

  def initialize
    @course_departments = CourseDepartment.find(:all, :order=>"id")
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")
    @course_statuses = CourseStatus.find(:all, :order=>"id")        
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list_courses_from_today_to_future
    @course_implementations = CourseImplementation.find_by_sql("SELECT * from vw_detailed_courses WHERE date_plan_start > current_date AND course_status_id=1 ")
    render 	:layout => "standard-layout"
  end

  def rekod_mohon_hadir
    if params[:employment] == nil
      params[:employment] = Hash.new
      params[:employment]['place_id'] = ''
    end
     render 	:layout => "standard-layout"
  end

  def search_record
	  if (params[:kementerian_id] == '' and params[:jabatan_id] == '' and params[:pejabat_id] == '')
	  	render :text => '<font style="color:red;">Sila pilih kementerian, jabatan atau pejabat</font> <input type="button" value="OK" onclick="history.back()">' and return
	  end
	  params[:orderby] = "name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]

    @profiles = Profile.find_by_sql("select pr.* from places pl, profiles pr, employments em where pl.id = #{params[:employment]['place_id']} and em.place_id = pl.id and em.profile_id = pr.id  ORDER BY #{@orderby} #{@arrow}")
    render :action => 'rekod_mohon_hadir'
  end

  def course_record
    @profile = Profile.find(session[:user].profile.id)
    if params[:search_code]
      @check = Profile.find_by_ic_number(params[:search_code])
      if @check != nil
      	@employment = Employment.find_by_profile_id(@check.id)
      	@students = CourseApplication.find(:all, :conditions => "profile_id = #{@check.id} AND student_status_id IN(5,8,9,10)", :order=>"date_apply")
      else
        @check = []
      	@students = []
      end
    else
      @check = []
      @students = []
    end
    render 	:layout => "standard-layout"
  end

  def p_evaluation_report
  	@student = CourseApplication.find(params[:id])
  end 
  
  def search_applicant
    render 	:layout => "standard-layout"
  end 
  
  def search_by_name
    sql = "SELECT p.*,e.place_id FROM employments e INNER JOIN profiles p ON p.id=e.profile_id
		   WHERE e.place_id=#{session[:user].profile.employments.first.place_id} 
		   AND p.name ILIKE '%#{params[:search_name]}%'
		   ORDER BY p.name"
    @profiles = Employment.find_by_sql(sql)

    render :action=>'search_applicant'
  end
  
  def search_by_ic
    @profiles = Profile.find(:all, :conditions => "ic_number ILIKE '%#{params[:search_code]}%'", :order => "ic_number")
    sql = "SELECT p.*,e.place_id FROM employments e INNER JOIN profiles p ON p.id=e.profile_id
		   WHERE e.place_id=#{session[:user].profile.employments.first.place_id} 
		   AND ic_number ILIKE '%#{params[:search_code]}%'
		   ORDER BY p.name"
    @profiles = Employment.find_by_sql(sql)
    render :action=>'search_applicant'    
  end
  
  def search_by_ministry
    @profiles = Profile.find_by_sql("select pr.* from places pl, profiles pr, employments em where pl.name ilike '%#{params[:search_min_name]}%' and em.place_id = pl.id and em.profile_id = pr.id order by pr.name")
    render :action=>'search_applicant'    
  end

  def search_applicant_status
    render 	:layout => "standard-layout"
  end 

  def semak_by_name
    sql = "SELECT ca.id as ca_id,p.id
	       FROM employments e 
	       INNER JOIN profiles p ON p.id=e.profile_id
		   INNER JOIN course_applications ca ON ca.profile_id=p.id 
		   WHERE e.place_id=#{session[:user].profile.employments.first.place_id} 
		   AND ca.student_status_id IN (1,2,3)
		   AND p.name ILIKE '%#{params[:search_name]}%'
		   ORDER BY ca.date_apply DESC"
    @profiles = Profile.find_by_sql(sql)
    render :action=>'search_applicant_status'
  end

  def semak_by_ic
    sql = "SELECT ca.id as ca_id,p.id
	       FROM employments e 
	       INNER JOIN profiles p ON p.id=e.profile_id
		   INNER JOIN course_applications ca ON ca.profile_id=p.id 
		   WHERE e.place_id=#{session[:user].profile.employments.first.place_id} 
		   AND ca.student_status_id IN (1,2,3)
		   AND ic_number ILIKE '%#{params[:search_code]}%'
		   ORDER BY ca.date_apply DESC"
    @profiles = Profile.find_by_sql(sql)
    render :action=>'search_applicant_status'
  end

  def semak_by_ministry
    sql = "SELECT ca.id as ca_id,p.id
	       FROM employments e 
		   INNER JOIN places pl ON pl.id=e.place_id
	       INNER JOIN profiles p ON p.id=e.profile_id
		   INNER JOIN course_applications ca ON ca.profile_id=p.id 
		   WHERE ca.student_status_id IN (1,2,3)
		   AND pl.name ilike '%#{params[:search_min_name]}%'
		   ORDER BY ca.date_apply DESC"
    @profiles = Profile.find_by_sql(sql)
    render :action=>'search_applicant_status'
  end
  
  def select_course   
  end

  def select_course_batal
    render 	:layout => "standard-layout"
  end

  def select_quiz
    render 	:layout => "standard-layout"
  end
  
  def mylist_peserta_quiz
    @course_implementation = CourseImplementation.find(params[:id]) if ( params[:id] && params[:id] != "")
    @quiz = @course_implementation.quizzes[0]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      sql = "select v.* from vw_detailed_applicants_all v
	         INNER JOIN employments e ON v.profile_id=e.profile_id
			 WHERE course_implementation_id='#{@course_implementation.id}' 
			 AND student_status_id IN(5,8,9,10)
	         AND e.place_id=#{session[:user].profile.employments[0].place_id}
			 ORDER BY #{@orderby} #{@arrow}"
      @students = CourseApplication.find_by_sql(sql)
    else
      @students = []
    end
  
  end
  
  def select_course_select_peserta
    @ci = CourseImplementation.find(params[:id])
    @course_implementation = @ci
    @profile = Profile.find(session[:user].profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    if @employment.place_id
      sql = "SELECT e.*,p.name FROM employments e INNER JOIN profiles p ON p.id=e.profile_id
		       WHERE e.place_id=#{@employment.place_id} 
			   AND p.name != 'ADMINISTRATOR'
			   ORDER BY p.name"
      sql = "SELECT e.*,p.name FROM employments e INNER JOIN profiles p ON p.id=e.profile_id
		       WHERE e.place_id=#{@employment.place_id} 
			   AND p.name != 'ADMINISTRATOR'
			   AND p.id NOT IN (SELECT profile_id FROM course_applications ca WHERE course_implementation_id=#{@ci.id})
			   ORDER BY p.name"

      @employments = Employment.find_by_sql(sql)
    else
      @employments = []
    end
  end

  def select_course_select_peserta_batal_klm
  	select_course_select_peserta_batal
  end

  def select_course_select_peserta_batal
    @course_implementation = CourseImplementation.find(params[:id]) if ( params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "date_apply" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      sql = "select v.* from vw_detailed_applicants_all v
	         INNER JOIN employments e ON v.profile_id=e.profile_id
			 WHERE course_implementation_id='#{@course_implementation.id}' 
			 AND student_status_id=1
	         AND e.place_id=#{session[:user].profile.employments[0].place_id}
			 ORDER BY #{@orderby} #{@arrow}"
      @students = CourseApplication.find_by_sql(sql)
      #@students = CourseApplication.find_by_sql("select * from vw_detailed_applicants_all WHERE course_implementation_id='#{@course_implementation.id}' AND student_status_id=1 ORDER BY #{@orderby} #{@arrow}")

    else
      @students = []
    end

    @list_title = "SENARAI PEMOHON YANG SEDANG DIPROSES"
  end

  def semak_status_mohon
    @course_implementation = CourseImplementation.find(params[:id]) if ( params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "date_apply" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]
	  
      sql = "select v.* from vw_detailed_applicants_all v
	         INNER JOIN employments e ON v.profile_id=e.profile_id
			 WHERE course_implementation_id='#{@course_implementation.id}' 
	         AND e.place_id=#{session[:user].profile.employments[0].place_id}
			 ORDER BY #{@orderby} #{@arrow}"
      @students = CourseApplication.find_by_sql(sql)

    else
      @students = []
    end

    @list_title = "SENARAI PEMOHON"
  end
    
  def select_course_mohon_kursus
    @ci = CourseImplementation.find(params[:course_implementation_id])
    @course_implementation = @ci
  end
  
  
  def update_user_cancel_klm
    @course_implementation = CourseImplementation.find(params[:id])
    params[:employ_ids].each do |id|
      @profile = Profile.find(id)
      #render :text=> @profile.name and return
      @course_application = CourseApplication.find(:first, :conditions=>"course_implementation_id=#{@course_implementation.id} AND profile_id=#{@profile.id}")
      @course_application.student_status_id = 12
      @course_application.cancel_reason = params[:cancel_reason]
      @course_application.cancel_spv_name = params[:cancel_spv_name]
      @course_application.cancel_spv_jawatan = params[:cancel_spv_jawatan]
      @course_application.cancel_spv_email = params[:cancel_spv_email]
      if @course_application.save
      	#EspekMailer.deliver_user_recorded(session[:user], @course_implementation.id)
      	#EspekMailer.deliver_ketua_jabatan(@course_application.id)
      	#EspekMailer.deliver_send_after_apply_course(@course_application.id)
      end
    end
    flash[:notice] = '<br>Pembatalan permohonan telah berjaya.'
    render :action => 'select_course_batal'
  
  end
  
  def apply_for_course
	
    params[:employ_ids].each do |id|
      @profile = Profile.find(id)
      #render :text=> @profile.name and return
      @course_application = CourseApplication.new
      @course_implementation = CourseImplementation.find(params[:course_implementation_id])
      @course_application.date_apply = params[:date_apply_month] + "/" + params[:date_apply_day] + "/" + params[:date_apply_year]
      @course_application.date_approval = params[:date_approval_month] + "/" + params[:date_approval_day] + "/" + params[:date_approval_year]
      @course_application.profile_id = @profile.id
      @course_application.nama_pejabat = @profile.opis
      @course_application.address1 = @profile.address1
      @course_application.address2 = @profile.address2
      @course_application.address3 = @profile.address3
      @course_application.supervisor_name = params[:course_application][:supervisor_name]
      @course_application.supervisor_jawatan = params[:course_application][:supervisor_jawatan]
      @course_application.supervisor_email = params[:course_application][:supervisor_email]
      @course_application.course_implementation_id = @course_implementation.id
      @course_application.course_id = @course_implementation.course_id
      @course_application.profile = @profile
      if @course_application.save
      	#EspekMailer.deliver_user_recorded(session[:user], @course_implementation.id)
      	#EspekMailer.deliver_ketua_jabatan(@course_application.id)
      	#EspekMailer.deliver_send_after_apply_course(@course_application.id)
      end
    end
    flash[:notice] = '<br>Data Pemohon berjaya disimpan.'
    render :action => 'select_course'
  end
  
  def check_course
  
  end
  
  def user_cancel_klm
    @ci = CourseImplementation.find(params[:id])
    @course_implementation = @ci
  end
  
  def user_cancel
    @course_application = CourseApplication.find(params[:id])
    @student = @course_application
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
  end

	def update_user_cancel
    @student = CourseApplication.find(params[:id])
	  params[:course_application][:student_status_id]   = "12" #BATAL KURSUS
	  
	  if @student.update_attributes(params[:course_application])
	  	#EspekMailer.user_cancel(@student.id)
   		flash[:notice] = "Permohonan kursus #{@student.profile.name} telah dibatalkan."
	  end

	  redirect_to("/hr/select_course_select_peserta_batal/#{@student.course_implementation.id}")
	end
	  
end
