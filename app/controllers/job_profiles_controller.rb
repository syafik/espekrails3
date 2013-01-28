# -*- encoding : utf-8 -*-
class JobProfilesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @job_profile_pages, @job_profiles = paginate :job_profiles, :per_page => 50, :order_by => "job_grade ASC, job_name ASC"
  end

  def show
    @job_profile = JobProfile.find(params[:id])
  end

  def new
    @job_profile = JobProfile.new
  end

  def create
    @job_profile = JobProfile.new(params[:job_profile])
    if @job_profile.save
      flash[:notice] = 'Skim Perkhidmatan Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @job_profile = JobProfile.find(params[:id])
  end

  def update
    @job_profile = JobProfile.find(params[:id])
    if @job_profile.update_attributes(params[:job_profile])
      flash[:notice] = 'Skim Perkhidmatan Telah Dikemaskinikan'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    JobProfile.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
