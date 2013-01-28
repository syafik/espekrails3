# -*- encoding : utf-8 -*-
class RegisterController < ApplicationController
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
    new
    render :action => 'new'
  end
  
  def new
  
  end	
  
  def search_by_name
  	@searches = CourseApplication.find_by_sql("select * from vw_detailed_applicants  WHERE student_status_id=4 AND personal_name ILIKE '%#{params[:name]}%'")
  	#render :text=> @searches.size
  end
  
  def search_by_nric
  	@searches = CourseApplication.find_by_sql("select * from vw_detailed_applicants  WHERE (student_status_id=1 OR student_status_id=2) AND nric ILIKE '%#{params[:nric]}%'")
  	render :action=> 'search_by_name'
  end

  def confirmed
	#@course_implementation = CourseImplementation.find(params[:id]) if params[:id]
	@course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

	if @course_implementation

	  params[:orderby] = "personal_name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]
	  
	  #@students = CourseApplication.find_by_sql("select * from vw_detailed_confirmed WHERE course_name='#{course.name}' order by #{params[:orderby]} #{params[:arrow]}")
	  @students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=4")
	 else
	  @students = []
	end
	@courses = Course.find(:all, :order=>"name")
  end

  def enroll_selected
	for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
	  if @student.update_attributes(:student_status_id => "5")
	  end
	end
	redirect_to("/register/enrolled/#{@student.course_implementation_id}?apply_status=accepted&course_implementation_code=#{@student.course_implementation.code}")
  end

  def enrolled
	@course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

	if @course_implementation

	  params[:orderby] = "personal_name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]
	  
	  #@students = CourseApplication.find_by_sql("select * from vw_detailed_confirmed WHERE course_name='#{course.name}' order by #{params[:orderby]} #{params[:arrow]}")
	  @students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
	 else
	  @students = []
	end
	@courses = Course.find(:all, :order=>"name")
  end

  def attendance
	@course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

	if @course_implementation

	  params[:orderby] = "personal_name" if !params[:orderby]
	  @orderby = params[:orderby]
	  params[:arrow] = "ASC" if !params[:arrow]
	  @arrow = params[:arrow]
	  
	  #@students = CourseApplication.find_by_sql("select * from vw_detailed_confirmed WHERE course_name='#{course.name}' order by #{params[:orderby]} #{params[:arrow]}")
	  @students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
	 else
	  @students = []
	end
	@courses = Course.find(:all, :order=>"name")

  end

end
