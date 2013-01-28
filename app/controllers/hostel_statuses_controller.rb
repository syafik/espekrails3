# -*- encoding : utf-8 -*-
class HostelStatusesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_status_pages, @hostel_statuses = paginate :hostel_statuses, :per_page => 10
  end

  def show
    @hostel_status = HostelStatus.find(params[:id])
  end

  def new
    @hostel_status = HostelStatus.new
  end

  def create
    @hostel_status = HostelStatus.new(params[:hostel_status])
    if @hostel_status.save
      flash[:notice] = 'HostelStatus was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_status = HostelStatus.find(params[:id])
  end

  def update
    @hostel_status = HostelStatus.find(params[:id])
    if @hostel_status.update_attributes(params[:hostel_status])
      flash[:notice] = 'HostelStatus was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
