# -*- encoding : utf-8 -*-
class AjaxController < ApplicationController

  def test
		a = "3"
		b = sprintf("%02d",a)
		if RUBY_PLATFORM == "i386-mswin32"
			render :text=> "#{RUBY_PLATFORM} ini windows" and return
		else
			render :text=> "#{RUBY_PLATFORM} bukan windows" and return
		end
  end

  def is_date_exist
		y = params[:y].to_i
		m = params[:m].to_i
		d = params[:d].to_i
		
		if Date.exist?(y, m, d)
			render :text=> "1"
		else
			render :text=> "0"
		end
  end

  def tr
    $_ = "pisang"

    if /piws/i
      render :text => "ada" and return
    else
      render :text => "tak ada" and return
    end

  end
  
  def ajax_tempoh
  	t = params[:tarikh].split("/");
    ymd = "#{t[2]}-#{t[1]}-#{t[0]}";
  	sql = "select * from course_implementations where '#{ymd}' >= date_start and '#{ymd}' <= date_end and id=#{params[:id]}";
  	@cimp = CourseImplementation.find_by_sql(sql);
    if (@cimp.size > 0)
      sql = "select * from attendances where course_implementation_id=#{params[:id]} limit 1"
      @att = Attendance.find_by_sql(sql);
      #if (@att.size > 0)
      #	1;
      #end
      render :text => "1"
    else
      render :text => "0"
    end
  end
  
  def ajax_nric
    @dr = params[:dr]
    @profile = Profile.find_by_ic_number(params[:ic_number])
    #@course_application = CourseApplication.find_by_profile_id(@profile.id)
    #@course_application = CourseApplication.find(:all, :conditions=>"profile_id = #{@profile.id} AND course_implementation_id = #{params[:course_implementation_id]}")
    if @profile
      #if @course_application
      #  render :text => "2"
      #else
	    @ret = "1"
      #end
    else
      @ret =  "0"
    end
  end

  def ajax_trainer_nric
    @profile = Profile.find_by_ic_number(params[:ic_number])
    if @profile
      if @profile.trainer
        render :text => "2"
      else
        render :text => "1"
      end
    else
      render :text => "0"
    end
  end
  
  def ajax_trainer_codename
    @profile = Profile.find_by_codename(params[:codename])
    if @profile
      render :text => "1"
    else
      render :text => "0"
    end
  end

  def check_existence_of_course_implementation_code
		@course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code])
  end

  def auto_tarikh_tutup
    require 'date'
		#start_date = "#{params[:start_year]}/#{params[:start_month]}/#{params[:start_day]}"
		#3date_arr = Course.find_by_sql("select date('#{start_date}') - 14 as close_date")
		#render :text => date_arr.first.close_date
		y = params[:start_year].to_i
		m = params[:start_month].to_i
		d = params[:start_day].to_i
		if Date.parse("#{y}-#{m}-#{d}")
			d = Date.new(y, m, d)
			ckin = d - 1
			mula = d - (30*3)
			abih = d - 14
			@date_baru =  "#{ckin},#{mula},#{abih}"
		else
			@date_baru =  "0"
		end
  end
  
  def isvalid_date
		sy = params[:sy].to_i if params[:sy]
		sm = params[:sm].to_i if params[:sm]
		sd = params[:sd].to_i if params[:sd]

		y = params[:y].to_i
		m = params[:m].to_i
		d = params[:d].to_i
		
		if Date.parse("#{y}-#{m}-#{d}")
			@r = "1"
      if Date.parse("#{sy}-#{sm}-#{sd}")
				start_d = Date.new(sy, sm, sd)
				end_d   = Date.new(y, m, d)
				if end_d < start_d
					@r = "2"
				end
			end
		else
			@r = "0"
		end
  end
  
  def staff_find_jawatan
  	if params[:staff_id] 
      @staff = Staff.find(params[:staff_id])
      j = nof{@staff.profile.employments.first.job_profile.job_name}
      e = nof{@staff.profile.email}
      f = nof{@staff.profile.fax}
      p = nof{@staff.profile.office_phone}
      render :text => "#{j},#{e},#{f},#{p}"
    else
      render :text => "0"
    end
  end
  
  def find_course_by_code
    params[:code] = params[:code].gsub(/_/,"/")
    @course_implementation = CourseImplementation.find_by_code(params[:code])
    if @course_implementation
      @ret = "#{@course_implementation.course.name.upcase}"
    else
      @ret = "0"
    end
  end
  def find_course_by_code_ca
    params[:code] = params[:code].gsub(/_/,"/")
    @course_implementation = CourseImplementation.find_by_code(params[:code])
    if @course_implementation
      @ret = "#{@course_implementation.course.name.upcase}"
    else
      @ret = "0"
    end
  end

  def find_course_by_code_2
    params[:code] = params[:code].gsub(/_/,"/")
    @input_id = params[:input_id]
    @course_implementation = CourseImplementation.find_by_code(params[:code])
    if @course_implementation
      @text = "#{@course_implementation.course.name.upcase}"
    else
      @text = "<font color=\"red\">&lt;&lt;Kursus Tidak Wujud</font> "
    end
  end

  def find_designation
    @job_profile = JobProfile.find(params[:job_grade])
    if @job_profile
      render :text => @job_profile.job_name
    else
      render :text => "Tiada jawatan"
    end
  end

  def ajax_find_course_field
    unless params[:id].blank?
      @fields = CourseField.where(:course_department_id => params[:id]).order("description ASC")
    else
      @fields = {}
    end
  end

  def ajax_find_coordinator
    unless params[:id].blank?
      @coordinators = Staff.where(:course_department_id=> params[:id]).joins(:profile).order("name ASC")
    else
      @coordinators = {}
    end

  end

  def enroll_applicant
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      if @student.update_attributes(:student_status_id => "5")
      end
    end
    render :text => "1"
  end

  def ajax_find_course_scheme
    @course = Course.find(params[:course_id])
    render :text=> "#{@course.course_scheme.description}=#{@course.course_scheme.id}"
    #render :text=> "SBL=2,PERLA=3"
  end

  def ajax_find_course_schedule
    @course = Course.find(params[:id])
    @schedules = Schedule.find(:all, :conditions=>"course_id = #{@course.id}", :order=>"date_start DESC")

    sch_arr = Array.new
	
    for schedule in @schedules
      str = schedule.date_start.to_formatted_s(:my_format_2) + " TO " + schedule.date_end.to_formatted_s(:my_format_2) + "=" + schedule.id.to_s
      sch_arr.push(str)
    end

    sch_str = sch_arr.join(",")
	
    render :text=> sch_str

    #render :text=> "skedulesatu=1,skedule2=2,skedule3=3,skedule4=4,PERLA=5"
  end

  def children_of_place
    if params[:id] != ""
      @ministry = Place.find(params[:id])
      @place_childrens = @ministry.children
    else
      render :text=> "0"
    end
  end

  def grand_and_children_of_place
    @pejabat = []
    if params[:id] != ""
      @place = Place.find(params[:id])
      @place.children.each do |place|
        @pejabat << place
        place.children.each do |p|
          @pejabat << p
        end
      end
    end
  end

  
  def facility_category_type
    #render :text=>params[:id] and return
    if params[:id] != ""
      #@types = FacilityCategory.find(:all, :conditions=>"facility_type_id = #{params[:id]}") if params[:id]!="")
      @types = FacilityType.find(:all, :conditions=>"facility_category_id = #{params[:id]}") if params[:id]!=""
      cord_arr = Array.new
      for type in @types
        str = type.description + "=" + type.id.to_s
        cord_arr.push(str)
      end
      cord_str = cord_arr.join(",")
      render :text=> cord_str
    else
      render :text=> ""
    end
  
  end
end
