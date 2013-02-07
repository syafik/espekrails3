# -*- encoding : utf-8 -*-
class FacilityStatusesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @facility_statuses = FacilityStatus.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @facility_status = FacilityStatus.find(params[:id])
  end

  def new
    @facility_status = FacilityStatus.new
  end

  def create
    @facility_status = FacilityStatus.new(params[:facility_status])
    if @facility_status.save
      flash[:notice] = 'Status Sumber Kemudahan Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @facility_status = FacilityStatus.find(params[:id])
  end

  def update
    @facility_status = FacilityStatus.find(params[:id])
    if @facility_status.update_attributes(params[:facility_status])
      flash[:notice] = 'Status Sumber Kemudahan Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @facility_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    FacilityStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
