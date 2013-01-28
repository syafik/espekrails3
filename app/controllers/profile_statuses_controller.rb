# -*- encoding : utf-8 -*-
class ProfileStatusesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @profile_status_pages, @profile_statuses = paginate :profile_statuses, :per_page => 10
  end

  def show
    @profile_status = ProfileStatus.find(params[:id])
  end

  def new
    @profile_status = ProfileStatus.new
  end

  def create
    @profile_status = ProfileStatus.new(params[:profile_status])
    if @profile_status.save
      flash[:notice] = 'ProfileStatus was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @profile_status = ProfileStatus.find(params[:id])
  end

  def update
    @profile_status = ProfileStatus.find(params[:id])
    if @profile_status.update_attributes(params[:profile_status])
      flash[:notice] = 'ProfileStatus was successfully updated.'
      redirect_to :action => 'show', :id => @profile_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProfileStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
