# -*- encoding : utf-8 -*-
class UserApplicationsController < ApplicationController
	layout "standard-layout"
  #	require "pdf/writer"

	def initialize
    @states = State.find(:all, :order=>"description")
    @genders = Gender.all
    @races = Race.find(:all, :order=>"id")
    @profile_statuses = ProfileStatus.all
    @religions = Religion.find(:all, :order=>"id")
    @countries = Country.all
    @marital_statuses = MaritalStatus.all
    @places = Place.find(:all, :conditions => "place_type_id = '2'")
    @relationships = Relationship.all
    @cert_levels = CertLevel.all
    @majors = Major.all
    @job_profiles = JobProfile.find(:all, :order=>"job_grade")
    @titles = Title.find(:all, :order=>"description")
    @course_departments = CourseDepartment.all
	end

	def show_user_cancel
		show
	end

	def user_cancel
		show
		if @course_application.student_status_id != 1
      flash[:notice] = 'Kursus Tidak Boleh Dibatalkan.'
      redirect_to :action => 'applied'
		end
	end

  def update_user_cancel
    @student = CourseApplication.find(params[:id])
	  #params[:course_application][:date_cfm_attend]     = params[:date_cfm_attend_month] + "/" + params[:date_cfm_attend_day] + "/" + params[:date_cfm_attend_year]
	  params[:course_application][:student_status_id]   = "12" #BATAL KURSUS
		t = Time.now
		today = t.strftime("%m/%d/%Y")
		params[:course_application][:cancel_date] = today


	  if @student.update_attributes(params[:course_application])
      EspekMailer.user_cancel(@student.id).deliver
      flash[:notice] = "Permohonan Kursus #{@student.course_implementation.code} Telah Dibatalkan."
	  end

    redirect_to("/user_applications/show_user_cancel/#{@student.id}")
  end

  def applied
    f = "student_status_id"
    s = Array.new
    s.push("#{f} = 1")
    s.push("#{f} = 2")
    s.push("#{f} = 3")
    s.push("#{f} = 4")
    s.push("#{f} = 5")
    #s.push("#{f} = 6")
    s.push("#{f} = 7")
    s.push("#{f} = 12")
    t = s.join(" OR ")
    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND (#{t})",
      :order=>"date_apply DESC,student_status_id")
    @courses = Course.find(:all, :order=>"name")
    render layout: "standard-layout"
  end

  def course_evaluation
    @course_application = CourseApplication.find(params[:id]) if params[:id]
    @question_types = QuestionType.find(:all, :order=>"description", :conditions => "question_template_id = #{@course_application.course_implementation.question_templates[0].id}")
    @course_evaluation = CourseEvaluation.new
  end

  def nilai
    @course_application = CourseApplication.find(params[:id]) if params[:id]
  end

  def result
    @course_application = CourseApplication.find(params[:id]) if params[:id]
    @quiz = Quiz.find_by_course_implementation_id(@course_application.course_implementation_id) if @course_application
  end

  def exam_before
    @course_application = CourseApplication.find(params[:id]) if params[:id]
    @quiz = Quiz.find_all_by_course_implementation_id(@course_application.course_implementation_id).last if @course_application
    @quiz_question = QuizQuestion.find_by_sql("SELECT * from quiz_questions where quiz_id = '#{@quiz.id}' order by id") if @quiz
    #@quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id) if @quiz
    logger.info @quiz
    logger.info @course_application.course_implementation_id
    if !@quiz.nil?
#      @quiz_answers = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers WHERE quiz_question_id = '#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before' ORDER BY 1")
      @check = QuizAnswer.find(:first, :conditions=> "quiz_id='#{@quiz.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before'", :order => "quiz_question_id")
      #@check = QuizAnswer.find(:first, :conditions=> "quiz_question_id='#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before'")
    end
    @quiz_answer = QuizAnswer.new
  end

  def exam_before_admin
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id) if @quiz
    if @quiz and @quiz_question
      @quiz_answers = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers WHERE quiz_question_id = '#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before' ORDER BY 1")
    end
    @quiz_answer = QuizAnswer.new
  end

  def tambah
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz.quiz_questions.size.times do |n|
      y = n + 1
      next if params["quiz_answer"]["#{y}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{y}"])
      @quiz_answer.update_attributes(:profile_id => "#{session[:user].profile.id}")
      @quiz_answer.update_attributes(:fraction => "before")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Diterima'
      redirect_to :action => 'attend'
    else
      render :action => 'exam_before'
    end
  end

  def tambah_update
    @quiz = Quiz.find(params[:id]) if params[:id]
    @test = QuizAnswer.find(:all, :conditions=> "quiz_id='#{@quiz.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before'")
    #@test = @quiz.quiz_answers
    for q in @test
      q.destroy
    end
    @quiz.quiz_questions.size.times do |n|
      y = n + 1
      next if params["quiz_answer"]["#{y}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{y}"])
      @quiz_answer.update_attributes(:profile_id => "#{session[:user].profile.id}")
      @quiz_answer.update_attributes(:fraction => "before")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Dikemaskini'
      redirect_to :action => 'attend'
    else
      render :action => 'exam_before'
    end
  end

  def tambah2
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz.quiz_questions.size.times do |n|
      y = n + 1
      next if params["quiz_answer"]["#{y}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{y}"])
      @quiz_answer.update_attributes(:profile_id => "#{session[:user].profile.id}")
      @quiz_answer.update_attributes(:fraction => "before")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Diterima'
      redirect_to :controller => 'quizzes'
    else
      render :action => 'exam_before_admin'
    end
  end

  def exam_after
    @course_application = CourseApplication.find(params[:id]) if params[:id]
    @quiz = Quiz.find_by_course_implementation_id(@course_application.course_implementation_id) if @course_application
    @quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id) if @quiz
    if @quiz != nil
      @quiz_answers = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers WHERE quiz_question_id = '#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'after' ORDER BY 1")
    end
    @quiz_answer = QuizAnswer.new
  end

  def exam_after_admin
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id) if @quiz
    if @quiz and @quiz_question
      @quiz_answers = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers WHERE quiz_question_id = '#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'after' ORDER BY 1")
    end
    @quiz_answer = QuizAnswer.new
  end

  def tolak
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz.quiz_questions.size.times do |n|
      x= n + 1
      next if params["quiz_answer"]["#{x}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{x}"])
      @quiz_answer.update_attributes(:profile_id => "#{session[:user].profile.id}")
      @quiz_answer.update_attributes(:fraction => "after")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Diterima'
      redirect_to :action => 'attend'
    else
      render :action => 'exam_after'
    end
  end

  def tolak2
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz.quiz_questions.size.times do |n|
      x= n + 1
      next if params["quiz_answer"]["#{x}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{x}"])
      @quiz_answer.update_attributes(:profile_id => "#{session[:user].profile.id}")
      @quiz_answer.update_attributes(:fraction => "after")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Diterima'
      redirect_to :controller => 'quizzes'
    else
      render :action => 'exam_after_admin'
    end
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @student_unprocesses = CourseApplication.find(:all, :conditions => "student_status_id ='1'")
    @student_accepts = CourseApplication.find(:all, :conditions => "student_status_id ='2'")
    @student_confirms = CourseApplication.find(:all, :conditions => "student_status_id ='4'")
    @student_rejects = CourseApplication.find(:all, :conditions => "student_status_id ='3'")
  end

  def unprocessed
    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND student_status_id=1")
    @courses = Course.find(:all, :order=>"name")
  end

  def offered
    #f = "student_status_id"
    #s = Array.new
    #s.push("#{f} = 2")
    #s.push("#{f} = 4")
    #s.push("#{f} = 7")
    #t = s.join(" OR ")

    @students = CourseApplication.find(:all, :conditions=>["profile_id = ? AND student_status_id = 2",session[:user].profile.id],
      :order=>"date_apply desc,student_status_id")
    @courses = Course.find(:all, :order=>"name")
    render layout: "standard-layout"
  end

  def attend
    if params[:testing]
      history
      return
    end

    f = "student_status_id"
    s = Array.new
    s.push("#{f} = 5")
    s.push("#{f} = 4")
    #s.push("#{f} = 7")
    t = s.join(" OR ")

    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND (#{t})",
      :order=>"student_status_id,date_apply")
    @courses = Course.find(:all, :order=>"name")
    today = Date.today
    for student in @students
      if student.course_implementation.date_plan_end < today
        @coz = CourseApplication.find_by_course_implementation_id_and_profile_id("#{student.course_implementation.id}","#{session[:user].profile.id}")
        #@coz.update_attributes(:student_status_id => "8")
      end
    end

    @a = Array.new
    for student in @students
      logger.info student.course_implementation.date_start
      logger.info today.class
      if (student.course_implementation.date_start <= today) and (student.course_implementation.date_end >= today)
        @a.push(student)
      end
    end

    @students = []
    @students = @a
    
    render layout: "standard-layout"
  end

  def completed
    f = "student_status_id"
    s = Array.new
    s.push("#{f} = 8")
    s.push("#{f} = 9")
    #s.push("#{f} = 7")
    t = s.join(" OR ")

    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND (#{t})",
      :order=>"student_status_id,date_apply DESC")
    @courses = Course.find(:all, :order=>"name")
  end

  def show_attendance
    @student = CourseApplication.find(params[:id])
    @course_implementation = @student.course_implementation
    @employment = Employment.find_by_profile_id(@student.profile_id)
    @att = Attendance.find_all_by_course_application_id(@student.id)
    #sql = "select id from attendances where course_application_id=#{@student.id} and course_implementation_id=#{@course_implementation.id}"
    #@attends = Attendance.find_by_sql(sql)
    jumlah_hadir = @att.size
    if jumlah_hadir > 0
      patut_hadir = @course_implementation.sesi_harian.size
      a = (jumlah_hadir.to_f / patut_hadir.to_f) * 100
      @percent = a.floor
    else
      @percent = 0
    end
  end

  def history
    #  f = "ca.student_status_id"
    #s = Array.new
    #s.push("#{f} = 3")
    #s.push("#{f} = 5")
    #s.push("#{f} = 6")
    #s.push("#{f} = 8")
    #s.push("#{f} = 9")
    #t = s.join(" OR ")
    #@students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND (#{t})",
    #					 :order=>"date_apply DESC,student_status_id")
    @students = CourseApplication.find_by_sql("select ca.* from course_applications ca, profiles pp, course_implementations ci where ca.profile_id = #{session[:user].profile.id}
  and pp.id = ca.profile_id and ca.student_status_id = 8 and ci.id = ca.course_implementation_id order by ci.date_plan_start, ca.date_apply desc, ca.student_status_id")

    @courses = Course.find(:all, :order=>"name")
    render layout: "standard-layout"
  end

  def rejected
    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND student_status_id=3")
    @courses = Course.find(:all, :order=>"name")
  end

  def confirmed
    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile.id} AND student_status_id=4")
    @courses = Course.find(:all, :order=>"name")
  end

  def all
    #@course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      #@students = CourseApplication.find_by_sql("select * from vw_detailed_confirmed WHERE course_name='#{course.name}' order by #{params[:orderby]} #{params[:arrow]}")
      @students = CourseApplication.find_all
    else
      @students = []
    end
    @courses = Course.find(:all, :order=>"name")
    @students = CourseApplication.find_all
  end


  def show
    @course_application = CourseApplication.find(params[:id])
	  @student = @course_application
    @relative = Relative.find_by_profile_id(@course_application.profile_id)
    @employment = Employment.find_by_profile_id(@course_application.profile_id)
    @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
  end

  def edit
    @course_application = CourseApplication.find(params[:id])
    @student = @course_application
    @profile = Profile.find(@course_application.profile_id)
    @relative = Relative.find_by_profile_id(@course_application.profile_id)
    @employment = Employment.find_by_profile_id(@course_application.profile_id)
    @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
  end


  def destroy
    CourseApplication.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def akuan_sah_hadir
    id = params[:course_application_ids][0]
    @student = CourseApplication.find(id)
    @course_application = @student
    @course_implementation = @student.course_implementation
  end

  def akuan_tidak_hadir
    akuan_sah_hadir
  end

  def tidak_hadir_wakil
    akuan_sah_hadir
  end

  def sah_hadir_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      params[:course_application][:date_cfm_attend]     = params[:date_cfm_attend_month] + "/" + params[:date_cfm_attend_day] + "/" + params[:date_cfm_attend_year]
      params[:course_application][:date_supervisor_cfm] = params[:date_supervisor_cfm_month] + "/" + params[:date_supervisor_cfm_day] + "/" + params[:date_supervisor_cfm_year]
      params[:course_application][:student_status_id]   = "4"
      @student.update_attributes(params[:course_application])
      EspekMailer.user_hadir(@student.id).deliver
      flash[:notice] = "Permohonan Kursus #{@student.course_implementation.code} Telah Disahkan Kehadiran."
    end
    redirect_to("/user_applications/offered/")
  end

  def sah_tidak_hadir_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      params[:course_application][:date_cfm_attend]     = params[:date_cfm_attend_month] + "/" + params[:date_cfm_attend_day] + "/" + params[:date_cfm_attend_year]
      params[:course_application][:date_supervisor_cfm] = params[:date_supervisor_cfm_month] + "/" + params[:date_supervisor_cfm_day] + "/" + params[:date_supervisor_cfm_year]
      params[:course_application][:student_status_id]   = "7"
      @student.update_attributes(params[:course_application])
    end
    redirect_to("/user_applications/offered/")
  end

  def create_wakil
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      params[:course_application][:date_cfm_attend]     = params[:date_cfm_attend_month] + "/" + params[:date_cfm_attend_day] + "/" + params[:date_cfm_attend_year]
      params[:course_application][:date_supervisor_cfm] = params[:date_supervisor_cfm_month] + "/" + params[:date_supervisor_cfm_day] + "/" + params[:date_supervisor_cfm_year]
      params[:course_application][:student_status_id]   = "7"
      @student.update_attributes(params[:course_application])
    end

    @p_wakil = Profile.find_by_ic_number(@student.wakil_ic_number)

    if !@p_wakil
      @p_wakil = Profile.new(:name => @student.wakil_name, :ic_number => @student.wakil_ic_number)
      @p_wakil.save_without_validation

      @employment = Employment.new(:profile_id => @p_wakil.id ,
        :place_id => @student.profile.employments[0].place_id
      )
      if params[:job_profile_name] != ""
        arr = params[:job_profile_name].split(",")
        job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
        @employment.job_profile_id = job_profile.id if job_profile
      end
      @employment.save_without_validation
    end

    @ca_wakil = CourseApplication.new(:profile_id => @p_wakil.id,
      :parent_id  => @student.id,
      :course_id  => @student.course_id,
      :course_implementation_id  => @student.course_implementation_id,
      :course_id  => @student.course_id,
      :student_status_id => 4,
      :supervisor_name    => @student.cfm_supervisor_name,
      :supervisor_jawatan => @student.cfm_supervisor_jawatan,
      :supervisor_email   => @student.cfm_supervisor_email
    )

    @ca_wakil.save
    redirect_to("/user_applications/offered/")
  end

  def surat_tawaran
    offered
  end

  def print_offer_letter
    if RUBY_PLATFORM == "i386-mswin32"
      path = "public/surat/"
    else
      path = "/aplikasi/www/instun/public/surat/"
    end

    if params[:id]
      student = CourseApplication.find(params[:id])
      filename = path + student.id.to_s + ".pdf"
      if !File.exist?(filename)
        render :text=> "<div align=\"center\"><b>Surat tawaran masih belum dikeluarkan.<br>Terima Kasih</b><br><br><a href=\"javascript: window.close()\">Keluar</a></div>"
      else
        redirect_to("/surat/" + student.id.to_s + ".pdf")
      end
    else
      render :text => "woi"
    end

  end
end
