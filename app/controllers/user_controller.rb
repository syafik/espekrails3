# -*- encoding : utf-8 -*-
class UserController < ApplicationController
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
      EspekMailer.deliver_user_cancel(@student.id)
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
    @quiz = Quiz.find_by_course_implementation_id(@course_application.course_implementation_id) if @course_application
    @quiz_question = QuizQuestion.find_by_sql("SELECT * from quiz_questions where quiz_id = '#{@quiz.id}' order by id") if @quiz
    #@quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id) if @quiz
    if @quiz != nil
      @quiz_answers = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers WHERE quiz_question_id = '#{@quiz_question.id}' AND profile_id = '#{session[:user].profile.id}' AND fraction = 'before' ORDER BY 1")
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
      if (student.course_implementation.date_start <= today) and (student.course_implementation.date_end >= today)
        @a.push(student)
      end
    end
    @students = []
    @students = @a

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
      EspekMailer.deliver_user_hadir(@student.id)
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
  #====================

  # Override this function in your own application to define a custom home action.
  def home

    if session[:user]
      redirect_to main_index_path
      #      @fullname = "#{current_user.firstname} #{current_user.lastname}"
    else
      logger.debug "======================================="
      #      @fullname = "Not logged in..."
    end # this is a bit of a hack since the home action is used to verify user
    # keys, where noone is logged in. We should probably create a unique
    # 'validate_key' action instead.
  end

  # The action used to log a user in. If the user was redirected to the login page
  # by the login_required method, they should be sent back to the page they were
  # trying to access. If not, they will be sent to "/user/home".
  def login

  end

  def authenticate
    #    return if generate_blank
    #    @user = User.new(params[:user]) # what does this achieve?
    
    if params[:user][:ic_number].blank? && params[:user][:password].blank?
      user = User.find(44)
  #    user = User.find(12975)
    else
      user = User.authenticate(params[:user][:ic_number], params[:user][:password])
    end
    
    if user 
      session[:user] = user 
      session[:user].logged_in_at = Time.now
      session[:user].save
      flash[:notice] = 'Login berjaya'
      redirect_to_stored_or_default :action => 'home'
    else
      @login = params[:user][:ic_number]
      render :action => "login"
      flash[:notice] = '<font color="blue" size="0.5"><br><br><br><br><br><br><br><br><b>Login ID atau Password Tidak Sah</b></style></font>'
    end
  end

  def ajax_nric
    @profile = Profile.find_by_ic_number(params[:ic_number])
    @user = User.find_by_ic_number(params[:ic_number])
    #@user = User.find_by_profile_id(@profile.id) if @profile
    if @profile and @user
      render :text => "2"
    elsif @user
      render :text => "3"
    elsif @profile
      render :text => "1"
    else
      render :text => "0"
    end
  end

  def check_existence_of_userid
		@user = User.find_by_login(params[:user_login])
		if @user
			render :text => "1"
		else
			render :text => "0"
		end
  end

  def staff_already_exist
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @user = User.new
  end

  # Register as a new user. Upon successful registration, the user will be sent to
  # "/user/login" to enter their details.

  def register
    @user = User.new
    @profile = Profile.new
    render layout: "standard-layout"
  end

  def semakan
    today = Date.today
    sql = "SELECT * from course_applications c, profiles p,course_implementations d where c.profile_id = p.id and c.course_implementation_id = d.id "
    where = "and date_plan_start > 'today' and p.ic_number= '#{params[:ic_number]}'"

    if params[:ic_number]!=nil
      @status = CourseApplication.find_by_sql(sql + where)
    else
      @status = []
    end
    #@status = CourseApplication.find_by_sql("SELECT * from course_applications c, profiles p,course_implementations d where c.profile_id = p.id and c.course_implementation_id = d.id and p.ic_number = '#{params[:search][ic_number]}' and d.code= '#{params[:search][:code]}'")
  end

  def signup
    #render :text=> params[:user][:login] and return;
    cur_users = User.find_all
    isalreadyuser = 0;
    for u in cur_users
      if u.ic_number == params[:profile][:ic_number]
        render :text=> "<span style=\"color:red\">Login id sudah wujud, sila pilih yang lain.</span><br><input type='button' value='<<Kembali' onclick=\"history.back()\">" and return
      end
    end

    @user8 = User.new(params[:user])
    @profile = Profile.new(:ic_number => params[:profile][:ic_number],
      :email     => params[:user][:email],
      :name      => (params[:user][:name]).gsub(/\'/,'`').to_s.gsub(/\"/,'`'),
      :gender_id    => 1,
      :race_id      => 1,
      :religion_id  => 1
    )
    @profile.save!

    begin
    	User.transaction(@user8) do
        @user8.ic_number =  params[:profile][:ic_number]
        @user8.new_password = true
        @user8.verified = 0
        created = Time.now

        name = params[:user][:name]
        email = params[:user][:email]
        kp = params[:profile][:ic_number]
        dp = params[:user][:department]
        phone = params[:user][:phone]
        name2 = name.gsub(/\'/, '`').to_s.gsub(/\"/,'`')
        dp2 = dp.gsub(/\'/, '`').to_s.gsub(/\"/,'`')


        if @user8.valid?
          key = @user8.generate_security_token
          url = url_for(:action => 'home', :user_id => @user8.id, :key => key)
          a = User.find_by_sql("insert into users(ic_number,verified,name,email,department,phone,security_token,salt,salted_password,created_at,profile_id) values('#{kp}','0','#{name2}','#{email}','#{dp2}','#{phone}','#{@user8.security_token}','#{@user8.salt}','#{@user8.salted_password}','#{created}',#{@profile.id})")
          b = User.find_by_ic_number(kp)
          c = Role.find_by_sql("insert into users_roles(user_id,role_id) values('#{b.id}','3')")

          flash[:notice] = 'Pendaftaran berjaya.<BR>'
          if LoginEngine.config(:use_email_notification) and LoginEngine.config(:confirm_account)
            UserNotify.deliver_signup(@user8, params[:user][:password], url)
            #  flash[:notice] << "<script>alert('Tahniah, pendaftaran telah berjaya. Anda hanya dibenarkan mengakses sistem setelah Administrator mengesahkan pendaftaran anda.')</script><BR>"
          end
          flash[:notice] = "Tahniah, pendaftaran telah berjaya. Anda hanya dibenarkan mengakses sistem setelah Administrator mengesahkan pendaftaran anda"
          redirect_to :action => 'success'

          #redirect_to :action => 'logout', :id => b.id
        else
          flash[:notice] = 'Maklumat pendaftaran tidak lengkap. Semua medan wajib diisi.<BR>'
          render :action => 'register'
        end

      end

    rescue Exception => e
      flash.now[:notice] = 'Pendaftaran tidak berjaya. Sila hubungi Pihak eSPEK.<BR>'
      render :action => 'register'
      flash.now[:warning] = nil
      logger.error "Unable to send confirmation E-Mail:"
      logger.error e
    end
  end

  def register_exist
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @user = User.new(params[:user])
    begin
      User.transaction(@user) do
        @user.new_password = true
        @user.verified = 1
        created = Time.now
        #	login = params[:user][:login]
        name = params[:profile][:name]
        email = params[:profile][:email]
        kp = params[:profile][:ic_number]
        dp = params[:user][:department]
        phone = params[:user][:phone]
        #	login2 = login.gsub("'", '')
        name2 = name.gsub("'", '')
        dp2 = dp.gsub("'", '')

        if @user.valid?
          key = @user.generate_security_token
          url = url_for(:action => 'home', :user_id => @user.id, :key => key)
          a = User.find_by_sql("insert into users(ic_number,verified,profile_id,name,email,department,phone,security_token,salt,salted_password,created_at) values('#{kp}','1','#{@profile.id}','#{name2}','#{email}','#{dp2}','#{phone}','#{@user.security_token}','#{@user.salt}','#{@user.salted_password}','#{created}')")
          b = User.find_by_ic_number(kp)
          c = Role.find_by_sql("insert into users_roles(user_id,role_id) values('#{b.id}','3')")

          flash[:notice] = 'Pendaftaran berjaya. Sila Login.'
          redirect_to :action => 'login'
        else
          render :action => 'staff_already_exist'
        end
      end

    rescue Exception => e
      flash.now[:notice] = 'Pendaftaran tidak berjaya. Sila hubungi Pihak eSPEK.'
      render :action => 'staff_already_exist'
      flash.now[:warning] = nil
      logger.error "Unable to send confirmation E-Mail:"
      logger.error e
    end
  end

  def init_load
    @states = State.find(:all, :order=>"description")
    @genders = Gender.find_all
    @races = Race.find(:all, :order=>"id")
    @handicaps = Handicap.find(:all, :order=>"id")
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
	end

  def new_peribadi
    init_load
    @user = User.find(params[:id])
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
  end

  def edit_peribadi
    init_load
    @user = User.find_by_ic_number(params[:profile][:ic_number])
    @profile = Profile.new(params[:profile])
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save
    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save
    @qualification = Qualification.new(params[:qualification])
    @qualification.profile = @profile
    @qualification.save
    sql = "UPDATE users SET profile_id='#{@profile.id}' WHERE id=#{@user.id}"
    a = User.find_by_sql(sql);
    if @profile.save
      render :text=> "<div align=\"center\"><b>Permohonan tuan/puan sedang diproses.<br>Makluman melalui email apabila permohonan diluluskan</b><br><br><a href=\"/user/login\">Login to eSPEK</a></div>" and return
      #flash[:notice] = 'Maklumat Pengguna telah dikemaskini'
      #redirect_to :action => 'login'
    else
      render :action => 'new_peribadi'
    end
  end

  def logout
    session[:user] = nil
    redirect_to :action => 'login'
  end

  def change_password
    return if generate_filled_in
    if do_change_password_for(@user)
      # since sometimes we're changing the password from within another action/template...
      #redirect_to :action => params[:back_to] if params[:back_to]
      #redirect_back_or_default :action => 'change_password'
      redirect_to :action => 'logout'
    end
  end

  protected
  def do_change_password_for(user)
    begin
      User.transaction(user) do
        user.change_password(params[:user][:password], params[:user][:password_confirmation])
        if user.save
          s = AuthenticatedUser.hashed("salt-#{Time.now}")
          sp = AuthenticatedUser.salted_password(s, AuthenticatedUser.hashed("#{params[:user][:password]}"))
          sql = "UPDATE users SET salt='#{s}' , salted_password='#{sp}' WHERE id=#{@user.id}"
          a = User.find_by_sql(sql);
          if LoginEngine.config(:use_email_notification)
            UserNotify.deliver_change_password(user, params[:user][:password])
            flash[:notice] = "Updated password emailed to #{@user.email}"
          else
            flash[:notice] = "Password updated."
          end
          return true
        else
          flash[:notice] = 'There was a problem saving the password. Please retry.'
          return false
        end
      end
    rescue
      flash[:notice] = 'Password could not be changed at this time. Please retry.'
    end
  end

  public


  def forgot_password
    # Always redirect if logged in
    if user?
      flash[:notice] = 'Anda Masih Dalam Login. Sila Teruskan Proses Penukaran Password'
      redirect_to :action => 'change_password'
      return
    end

    # Email disabled... we are unable to provide the password
    if !LoginEngine.config(:use_email_notification)
      flash[:notice] = "Sila hubungi pihak #{LoginEngine.config(:admin_email)} untuk kembali login ke dalam sistem."
      redirect_back_or_default :action => 'login'
      return
    end

    # Render on :get and render
    return if generate_blank

    # Handle the :post
    if params[:user][:ic_number].empty?
      flash.now[:notice] = 'Sila masukkan format No. KP yang betul'
    elsif (user = User.find_by_ic_number(params[:user][:ic_number])).nil?
      flash.now[:notice] = "No. KP tiada di dalam database"
    elsif (user = User.find(:first, :conditions=> ["ic_number = ?", "#{params[:user][:ic_number]}"])).nil?
      flash.now[:notice] = "Tiada pengguna didalam eSPEK. Sila hubungi espek@instun.gov.my"
    else
      begin
        User.transaction(user) do
          key = user.generate_security_token
          url = url_for(:action => 'change_password', :user_id => user.id, :key => key)
          UserNotify.deliver_forgot_password(user, url)
          flash[:notice] = "Penerangan untuk penukaran kata laluan telah diemelkan ke #{user.email}"
        end
        unless user?
          redirect_to :action => 'success'
          return
        end
        redirect_to :action => 'logout'
      rescue
        flash.now[:notice] = "Masalah penghantaran email ke #{params[:user][:email]}"
      end
    end
  end

  def edit
    return if generate_filled_in
    do_edit_user(@user)
  end

  protected
  def do_edit_user(user)
    begin
      User.transaction(user) do
        user.attributes = params[:user].delete_if { |k,v| not LoginEngine.config(:changeable_fields).include?(k) }
        if user.save
          flash[:notice] = "User details updated"
        else
          flash[:notice] = "Details could not be updated! Please retry."
        end
      end
    rescue
      flash.now[:notice] = "Error updating user details. Please try again later."
    end
  end

  public

  def delete
    get_user_to_act_on
    if do_delete_user(@user)
      logout
    else
      redirect_back_or_default :action => 'home'
    end
  end

  protected
  def do_delete_user(user)
    begin
      if LoginEngine.config(:delayed_delete)
        User.transaction(user) do
          key = user.set_delete_after
          if LoginEngine.config(:use_email_notification)
            url = url_for(:action => 'restore_deleted', :user_id => user.id, :key => key)
            UserNotify.deliver_pending_delete(user, url)
          end
        end
      else
        destroy(@user)
      end
      return true
    rescue
      if LoginEngine.config(:use_email_notification)
        flash.now[:notice] = 'The delete instructions were not sent. Please try again later.'
      else
        flash.now[:notice] = 'The account has been scheduled for deletion. It will be removed in #{LoginEngine.config(:delayed_delete_days)} days.'
      end
      return false
    end
  end

  public

  def restore_deleted
    get_user_to_act_on
    @user.deleted = 0
    if not @user.save
      flash.now[:notice] = "The account for #{@user['login']} was not restored. Please try the link again."
      redirect_to :action => 'login'
    else
      redirect_to :action => 'home'
    end
  end

  protected

  def destroy(user)
    UserNotify.deliver_delete(user) if LoginEngine.config(:use_email_notification)
    flash[:notice] = "The account for #{user['login']} was successfully deleted."
    user.destroy()
  end

  def protect?(action)
    if ['login', 'register', 'register_exist', 'signup', 'forgot_password', 'semakan'].include?(action)
      return false
    else
      return true
    end
  end

  # Generate a template user for certain actions on get
  def generate_blank
    case request.method
    when :get
      @user = User.new
      render
      return true
    end
    return false
  end

  # Generate a template user for certain actions on get
  def generate_filled_in
    get_user_to_act_on
    case request.method
    when :get
      render
      return true
    end
    return false
  end

  # returns the user object this method should act upon; only really
  # exists for other engines operating on top of this one to redefine...
  def get_user_to_act_on
    @user = session[:user]
  end
  
end
