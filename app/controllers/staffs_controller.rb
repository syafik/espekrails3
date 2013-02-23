# -*- encoding : utf-8 -*-
class StaffsController < ApplicationController
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
    #@courses = Course.find_all
    #@course_implementations = CourseImplementation.find_all
    super
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @staffs = Staff.find_by_sql("select * from profiles join staffs on staffs.profile_id=profiles.id and staffs.status='1' order by name ASC")
    #@staff_pages, @staffs = paginate :staff, :per_page => 100
  end

  def search
    #render layout: 'standard-layout'
  end

  def search_by_name
    @staffs = Staff.find_by_sql("select * from staffs,profiles WHERE profiles.id = staffs.profile_id and staffs.status='1' AND name ILIKE '%#{params[:name]}%'")
    #render layout: 'standard-layout'
  end

  def search_by_phone
    @staffs = Staff.find_by_sql("select * from staffs,profiles WHERE profiles.id = staffs.profile_id and staffs.status='1' AND mobile ILIKE '%#{params[:phone]}%'")
  end

  def search_by_dept
    @staffs = Staff.find_by_sql("select * from staffs,profiles WHERE profiles.id = staffs.profile_id and staffs.status='1' AND staffs.course_department_id = #{params[:course_department_id]}")
  end

  def show
    @staff = Staff.find(params[:id])
    @profile = Profile.find(@staff.profile_id)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification = @staff.profile.qualifications

    #render layout: 'standard-layout'
  end

  def new
    @staff = Staff.new
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification = Qualification.new

    #render layout: 'standard-layout'
  end

  def new_but_staff_already_exist
    @staff = Staff.new
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
  end

  def create_but_staff_already_exist
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @staff = Staff.new(params[:staff])
    @q = Qualification.new(params[:qualification])
    @profile.qualifications.push(@q)
    @staff.profile = @profile
    if @staff.save
      flash[:notice] = 'Kakitangan berjaya disimpan.'
      redirect_to :action => 'list'
    else
      render :action => 'new_but_staff_already_exist'
    end
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    @staff = Staff.new(params[:staff])
    @staff.profile = @profile

    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save

    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save

    if @staff.save
      flash[:notice] = 'Kakitangan berjaya disimpan.'
      redirect_to :action => 'list'
    else
      @profile.destroy
      render :action => 'new'
    end
  end

  def edit
    @staff = Staff.find(params[:id])
    @qualification = Qualification.find_by_profile_id(@staff.profile_id)
    @relative = Relative.find_by_profile_id(@staff.profile_id)
    @employment = Employment.find_by_profile_id(@staff.profile_id)
    @staff.profile = Profile.find(@staff.profile_id)
    @profile = @staff.profile
    if @employment
      @job_profile = @employment.job_profile
    else
      @employment = Employment.new
      @job_profile = JobProfile.new
    end
    #render layout: 'standard-layout'
  end

  def update
    @staff = Staff.find(params[:id])
    @profile = Profile.find(@staff.profile_id)

    if @profile.update_attributes(params[:profile])
      flash[:notice] = 'Data Pemohon berjaya dikemaskini.'
    else
      render :action => 'edit'
    end

    @relative = Relative.find_by_profile_id(@profile.id)
    if @relative
      if @relative.update_attributes(params[:relative])
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'edit'
      end
    else
      @relative = Relative.new(params[:relative])
      @relative.profile = @profile
      if @relative.save
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'edit'
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
        render :action => 'edit'
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
        render :action => 'edit'
      end
    end

    @qualifications = @profile.qualifications
    for q in @qualifications
      q.destroy
    end
    if params[:cert_level_ids] and params[:cert_level_ids].size > 0
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :major_id => params[:major_ids][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""

        @profile.qualifications.push(q) if q
      end
    end

    if @staff.update_attributes(params[:staff])
      flash[:notice] = 'Data Kakitangan Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @staff
    else
      render :action => 'edit'
    end

  end

  def new_teaching_course
    @staff = Staff.find(params[:id])
    @staff.profile = Profile.find(@staff.profile_id)
    @profile = @staff.profile
    @courses = Course.find(:all, :order => "name")
  end

  def create_teaching_course
    @staff = Staff.find(params[:id])
    @profile = @staff.profile

    @staff.courses.push(Course.find(@params[:course_ids]))
    #@staff.course_ids = @params[:course_ids]
    #@staff.update_attributes
    #render :action => 'show', :id=>@staff
    redirect_to("/staffs/show/#{@staff.id}?what=show_course")
  end

  def remove_course
    @staff = Staff.find(params[:id])
    #new_courses = Array.new
    #for course in @staff.courses
    #  new_courses.push(course.id) if course.id != params[:course_id].to_i
    #end
    #@staff.course_ids = []
    #@staff.course_ids = new_courses
    a = Student.find_by_sql("delete from courses_trainers where course_id=#{params[:course_id]} and trainer_id=#{@trainer.id}")
    redirect_to("/trainer/show/#{@trainer.id}?what=show_course")
  end

  def new_qualification
    @staff = Staff.find(params[:id])
    @profile = @staff.profile
    @qualification = Qualification.new
  end

  def create_qualification
    @staff = Staff.find(params[:id])
    @staff.profile.qualifications.push(Qualification.new(params[:qualification]))
    redirect_to("/staff/show/#{@staff.id}?what=show_qualification")
  end

  def remove_qualification
    @qualification = Qualification.find(params[:qualification_id])
    @qualification.destroy
    redirect_to("/staff/show/#{params[:id]}?what=show_qualification")
  end

  def destroy
    @staff = Staff.find(params[:id])
    #@staff.destroy
    @staff.update_attributes(:status => "0")
    redirect_to :action => 'list'
  end
end
