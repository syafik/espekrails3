# -*- encoding : utf-8 -*-
class HostelProfilesController < ApplicationController
  layout "standard-layout"
  def initialize
	@profiles = Profile.find(:all, :order=>"name")
	@hostels = Hostel.find(:all, :order=>"id")
	@hostel_blocks = HostelBlock.find(:all, :order=>"id")
	@hostel_policies = HostelPolicy.find(:all, :order=>"id")
	@job_profiles = JobProfile.find_all
	@opens = Hostel.find_by_sql("SELECT * FROM hostels WHERE id NOT IN (SELECT hostel_id FROM hostel_profiles)")
  end  
  
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_profile_pages, @hostel_profiles = paginate :hostel_profiles, :per_page => 10
	@courses = VwDetailedCourse.find(:all)
  end

  def show
    #@hostel_profile = HostelProfile.find(params[:id])
	new
  end

  def new
    @profile = Profile.find(params[:profile_id])
    @employment = Employment.find_by_profile_id(@profile.id)
    @course_application = CourseApplication.find_by_profile_id(@profile.id)
    @hostel_profile = HostelProfile.new
	@rank = Employment.find_by_sql("SELECT * FROM employments WHERE profile_id = #{@profile.id} ")
  end

  def create
	profile_id = params[:profile_id]
    block_id = params[:block_id]
    level = params[:level]
    room = params[:room]
    expected = params[:datei]

	@profile = Profile.find(profile_id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @course_application = CourseApplication.find_by_profile_id(@profile.id)

	@rank = Employment.find_by_sql("SELECT * FROM employments WHERE profile_id = #{profile_id} ")
	
    beds = Hostel.find_by_sql("SELECT id FROM hostels WHERE block_id = #{block_id} AND level = #{level} AND room = #{room} AND id NOT IN (SELECT hostel_id FROM inside_hostels) LIMIT 1")
    @bed = Hostel.find(:first, :conditions=>"block_id = #{block_id} AND level = #{level} AND room = #{room} AND id NOT IN (SELECT hostel_id FROM inside_hostels)")
	jum = beds.size
    for bed in beds
      data = bed.id
    end
    
    t = Time.now
    today = t.strftime("%m/%d/%Y")
    
    @hostel_profile = HostelProfile.new
    @hostel_profile.profile_id = profile_id
    @hostel_profile.hostel_id = data
    @hostel_profile.date_in = today
    @hostel_profile.expected_date_out = expected
    #@date_in = today
    #render :text => @hostel_profile.date_in
    
	if @profile.gender_id != @bed.gender_id
		flash[:notice] = "<font color=\"red\">Peserta hanya boleh mendaftar ke asrama #{@profile.gender.description.downcase} sahaja.<br>Sila pilih blok yang lain.</font>"
		render :action => 'new' and return
	end

	if @hostel_profile.save
      flash[:notice] = 'Pendaftaran asrama berjaya'
      redirect_to :action => 'show',:id => @hostel_profile.id, :profile_id => profile_id, :dari => 1
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_profile = HostelProfile.find(params[:id])
    @profile = Profile.find(params[:profile_id])
    @block = Hostel.find_by_sql("SELECT * FROM hostels WHERE gender_id = #{@profile.gender_id} ORDER BY block_id limit 1")
    @rank = Employment.find_by_sql("SELECT * FROM employments WHERE profile_id = #{@profile.id} ")
  end

  def update
    @hostel_profile = HostelProfile.find(params[:id])
    @hostel_profile.date_out = params[:out]
    #render :text => @hostel_profile.date_out
    
    if @hostel_profile.update_attributes(params[:hostel_profile])
      flash[:notice] = 'Daftar keluar berjaya.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  def change
    @hostel_profile = HostelProfile.find(params[:id])
    @profile = Profile.find(params[:profile_id])
    @block = Hostel.find_by_sql("SELECT * FROM hostels WHERE gender_id = #{@profile.gender_id} ORDER BY block_id limit 1")
    @rank = Employment.find_by_sql("SELECT * FROM employments WHERE profile_id = #{@profile.id} ")
  end

  def upchange
    block_id = params[:block_id]
    level = params[:level]
    room = params[:room]
    profile_id = params[:profile_id]
    id = params[:hp_id]
    old = params[:old]
    
    beds = Hostel.find_by_sql("SELECT id FROM hostels WHERE block_id = #{block_id} AND level = #{level} AND room = #{room} AND id NOT IN (SELECT hostel_id FROM inside_hostels) LIMIT 1")
    jum = beds.size
    for bed in beds
      data = bed.id
    end
    
    @hostel_history = HostelHistory.new
    @hostel_history.profile_id = profile_id
    @hostel_history.hostel_id = old
    @hostel_history.save
    
    @hostel_profile = HostelProfile.find(id)
    @hostel_profile.hostel_id = data
    #render :text => @hostel_profile.hostel_id
        
    if @hostel_profile.update_attributes(params[:hostel_profile])
      flash[:notice] = 'Pertukaran bilik berjaya.'
      redirect_to :action => 'detail',:id => id, :profile_id => profile_id, :dari => 2
    else
      render :action => 'change' ,:id => id, :profile_id => profile_id
    end
  end
  
  def detail
    @hostel_profile = HostelProfile.find(params[:id])
    @profile = Profile.find(params[:profile_id])
    @block = Hostel.find_by_sql("SELECT * FROM hostels WHERE gender_id = #{@profile.gender_id} ORDER BY block_id limit 1")
    @rank = Employment.find_by_sql("SELECT * FROM employments WHERE profile_id = #{@profile.id} ")
  end
  

  def destroy
    HostelProfile.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
