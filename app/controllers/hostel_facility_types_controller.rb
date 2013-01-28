# -*- encoding : utf-8 -*-
class HostelFacilityTypesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_facility_type_pages, @hostel_facility_types = paginate :hostel_facility_types, :per_page => 10
  end

  def show
    @hostel_facility_type = HostelFacilityType.find(params[:id])
  end
  
  def new_popup
    @hostel_facility_type = HostelFacilityType.new
  end

  def create_popup
    @hostel_facility_type = HostelFacilityType.new(params[:hostel_facility_type])
    if @hostel_facility_type.save
      #flash[:notice] = 'CourseLocation was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end
  

  def new
    @hostel_facility_type = HostelFacilityType.new
  end

  def create
    @hostel_facility_type = HostelFacilityType.new(params[:hostel_facility_type])
    if @hostel_facility_type.save
      flash[:notice] = 'HostelFacilityType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_facility_type = HostelFacilityType.find(params[:id])
  end

  def update
    @hostel_facility_type = HostelFacilityType.find(params[:id])
    if @hostel_facility_type.update_attributes(params[:hostel_facility_type])
      flash[:notice] = 'HostelFacilityType was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_facility_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelFacilityType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
