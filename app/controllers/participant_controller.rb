# -*- encoding : utf-8 -*-
class ParticipantController < ApplicationController
	layout "standard-layout"
    require "pdf/writer"

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
    list
    render :action => 'list'
  end

  def list_old
	@cond = Array.new()
	@cond.push("course_id="   +  params[:course_id])  if params[:course_id].to_i > 0
	@cond.push("schedule_id=" +  params[:schedule_id])  if params[:schedule_id].to_i > 0
	@cond.push("c_field_id="  +  params[:course_field_id])  if params[:course_field_id].to_i > 0
	@cond.push("c_scheme_id=" +  params[:course_scheme_id]) if params[:course_scheme_id].to_i > 0
	@cond.push("c_status_id=" +  params[:course_status_id]) if params[:course_status_id].to_i > 0

	
	@a = @cond.join(" AND ")

	sql = "SELECT * FROM vw_detailed_participants"
	sql += " WHERE " + @a if @a != ""
	
	@participants = Profile.find_by_sql(sql)

  end

  def list
	course = Course.find(params[:id]) if params[:id]
    if course
	  @course = course
	  @selected_schedule_id = params[:schedule_id]

	  params[:orderby] = "personal_name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]

	  params[:schedule_id] = 0 if !params[:schedule_id]
	  
	  @participants = Student.find_by_sql("select * from vw_detailed_participants WHERE course_name='#{course.name}' AND schedule_id=#{params[:schedule_id]} order by #{params[:orderby]} #{params[:arrow]}")
	 else
	  @participants = []
	end

	@courses = Course.find(:all, :order=>"name")

  end


  def list_company
	course = Course.find(params[:id]) if params[:id]
    if course
	  @course = course
	  @selected_schedule_id = params[:schedule_id]

	  params[:orderby] = "personal_name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]
	  
	  @participants = Student.find_by_sql("select * from vw_detailed_participants WHERE course_name='#{course.name}' AND schedule_id=#{params[:schedule_id]} AND student_type_id=4 order by #{params[:orderby]} #{params[:arrow]}")
	 else
	  @participants = []
	end

	@courses = Course.find(:all, :order=>"name")

	render :action=> 'list'

  end
  
  def show
    @course_application = CourseApplication.find(params[:id])
	@student = @course_application
	@profile = @student.profile
    @relative = Relative.find_by_profile_id(@course_application.profile_id)
    @employment = Employment.find_by_profile_id(@course_application.profile_id)
    @qualification =Qualification.find_by_profile_id(@course_application.profile_id)
  end

  def show_payment
    @student = Student.find(params[:id])
  end
  
  def add_payment
    @student = Student.find(params[:id])
  end
  
  def create_payment
    @student = Student.find(params[:id])
	@payment = Payment.new(params[:payment])
	@payment.student_id = @student.id
	@payment.save if @payment.amount
	flash[:notice] = 'Payment was successfully recorded.'
	#redirect_to :action => 'show_payment', :id => @student
	redirect_to("/participant/show/#{@student.id}?what=show_payment")
  end

  
  def new
    @personal = Personal.new
  end

  def edit
    @student = Student.find(params[:id])
	@profile = @student.profile
	@course_schemes = CourseScheme.find(:all, :order => "description")
	@courses = Course.find(:all, :order=>"name")
  end
  
  def update
    @student = Student.find(params[:id])
    @profile = @student.profile

    if @profile.update_attributes(params[:profile])
	  flash[:notice] = 'Student profile was successfully updated.'
    else
	  @courses = Course.find(:all, :order=>"name")
      render :action => 'edit' and return
	end

    if @student.update_attributes(params[:student])
      flash[:notice] = 'Student was successfully updated.'
      redirect_to :action => 'show', :id => @student
    else
      render :action => 'edit'
    end
  end

  def update_all
  
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
    @profile.courses = Course.find(params[:course_ids]) if @params[:course_ids]
    @profile.schedules = Schedule.find(params[:schedule_ids]) if @params[:schedule_ids]
    
    @schedule_id = Schedule.find(params[:schedule_ids])
		
		@student = Student.new(params[:student])
		@student.save
		
		@payment = Payment.new(params[:payment])
		#@payment.profile = Profile.find(@payment.profile_id)
		@payment.profile = @profile
		@payment.schedule = @profile.schedules[0]
		
		a = @profile.courses[0]
		a.fee
	
		amounts = Payment.find_by_sql (" SELECT id, sum(amount) FROM payments 
		                                 WHERE profile_id = '#{@profile.id}' 
		                                 AND schedule_id = '#{@profile.schedules[0].id}' GROUP BY id ")
		data = amounts[0]
		
		if amounts.size != 0
			#######render :text => 'heheh'
		else
			@payment.save
			
		end
	for amount in amounts
	end
        masuk = amount.sum
				db = a.fee
				
				balance = db.to_i - masuk.to_i
				
				baki = balance.to_i
				if baki > 0
					#@payment.save					
					render :text => @profile.schedules[0].id
				else
					render :text => 'dah abis bayar la'
				end	
		
		@qualification = Qualification.new(params[:qualification])		
		@qualification.profile = @profile
		@qualification.save
		
    #flash[:notice] = 'Profile was successfully updated.'
      
    #redirect_to :action => 'edit', :id => @profile
    
   	end
	end
    
  def destroy
    student = Student.find(params[:id])
	@course = student.course
    @selected_schedule_id = student.schedule_id
	Student.find(params[:id]).destroy
    #redirect_to :action => 'list', :id=>@course.id
	redirect_to("/participant/list/#{@course.id}?schedule_id=#{@selected_schedule_id}")
  end


  def complete_course
    @profile = Profile.find(params[:id])
    student = Student.find_by_profile_id(params[:id])
    if student.update_attributes(:student_status_id => "5")
	  flash[:notice] = 'Participant successfully completed course.'
    end

	redirect_to :action => 'list'
  end

  def complete_course_all
    for profile_id in params[:profile_ids]
	  @profile = Profile.find(profile_id)
      student = Student.find_by_profile_id(profile_id)
      student.update_attributes(:student_status_id => "5")
    end
    
	flash[:notice] = 'Participants successfully completed course.' 
	redirect_to :action => 'list'
  end

  def quit_course
    @profile = Profile.find(params[:id])
    student = Student.find_by_profile_id(params[:id])
    if student.update_attributes(:student_status_id => "6")
	  flash[:notice] = 'Participant quit course.'
    end

	redirect_to :action => 'list'
  end

  #####################################################333
  def pdf
	
	filename = "aaaaaaaa.pdf" 
    
	gen_pdf (filename)
      #redirect_to("#{@request.relative_url_root}/public/pdf_certificate/" + filename)
      redirect_to("/pdf_certificate/" + filename)
  end

  private
  def gen_pdf (file)
	
	pdf = PDF::Writer.new
	pdf.select_font("Times-Roman")
    
    pdf.text "Anjuran\n", :font_size => 10, :justification => :center
    pdf.text "<b>dsf;ldsflkfds;l</b>\n", :font_size => 15, :justification => :center
    pdf.text "\n", :font_size => 5, :justification => :center
    pdf.text "dan\n", :font_size => 10, :justification => :center
    pdf.text "<b>Pusat Pembangunan Tenaga Industri Johor(PUSPATRI)</b>\n\n", :font_size => 15, :justification => :center
    pdf.text "\n\n", :font_size => 15, :justification => :center
    pdf.text "\n\n", :font_size => 15, :justification => :center
    pdf.text "\n\n", :font_size => 15, :justification => :center
    pdf.text "___________________________", :font_size => 15, :justification => :right
    pdf.text "\n\n", :font_size => 15, :justification => :center

      x = pdf.absolute_left_margin
      y = pdf.absolute_bottom_margin
      pdf.add_text(x, y, "Hello, Ruby.", 72, 45)

    pdf.save_as("public/pdf_certificate/" + file)

  end


end
