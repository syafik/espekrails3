# -*- encoding : utf-8 -*-
class FacilityPurposesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @facility_purpose_pages, @facility_purposes = paginate :facility_purposes, :per_page => 10
  end

  def show
    @facility_purpose = FacilityPurpose.find(params[:id])
  end

  def new
    @facility_purpose = FacilityPurpose.new
  end

  def create
    @facility_purpose = FacilityPurpose.new(params[:facility_purpose])
    if @facility_purpose.save
      flash[:notice] = 'FacilityPurpose was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @facility_purpose = FacilityPurpose.new
  end

  def create_popup
    @facility_purpose = FacilityPurpose.new(params[:facility_purpose])
    if @facility_purpose.save
      #flash[:notice] = 'CourseField was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end
  

  def edit
    @facility_purpose = FacilityPurpose.find(params[:id])
  end

  def update
    @facility_purpose = FacilityPurpose.find(params[:id])
    if @facility_purpose.update_attributes(params[:facility_purpose])
      flash[:notice] = 'FacilityPurpose was successfully updated.'
      redirect_to :action => 'show', :id => @facility_purpose
    else
      render :action => 'edit'
    end
  end

  def destroy
    FacilityPurpose.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
