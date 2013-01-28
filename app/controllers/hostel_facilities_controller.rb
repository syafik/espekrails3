# -*- encoding : utf-8 -*-
class HostelFacilitiesController < ApplicationController
  layout "standard-layout"
  
  def initialize
	@hostel_facility_types = HostelFacilityType.find(:all, :order=>"id")
	@facility_statuses = FacilityStatus.find(:all, :order=>"id")
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_facility_pages, @hostel_facilities = paginate :hostel_facilities, :per_page => 10
  end

  def show
    @hostel_facility = HostelFacility.find(params[:id])
  end
  
  def newf
    @hostel_facility = HostelFacility.new
  end

  def createf
    @hostel_facility = HostelFacility.new(params[:hostel_facility])
    bils = params[:bilangan]
    
    @hostel_facility_type = HostelFacilityType.find(@hostel_facility.hostel_facility_type_id)    
    
    #render :text => @facility_category.code 
    querys = HostelFacility.find_by_sql("SELECT * FROM hostel_facilities WHERE hostel_facility_type_id = #{@hostel_facility.hostel_facility_type_id}")
    jums = querys.size
    #render :text => jums 
        
    x=jums+1
    bils = bils.to_i
    bils.times do
      @hostel_facility = HostelFacility.new(params[:hostel_facility])
      @hostel_facility.code = @hostel_facility_type.code+""+x.to_s
      @hostel_facility.save
      #render :text => @facility.code 
      x=x+1  
    end  
    
    if @hostel_facility.save
      flash[:notice] = 'Sumber kemudahan domestik berjaya ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
    
  end
  

  def new
    @hostel_facility = HostelFacility.new
  end

  def create
    @hostel_facility = HostelFacility.new(params[:hostel_facility])
    if @hostel_facility.save
      flash[:notice] = 'HostelFacility was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_facility = HostelFacility.find(params[:id])
  end

  def update
    @hostel_facility = HostelFacility.find(params[:id])
    if @hostel_facility.update_attributes(params[:hostel_facility])
      flash[:notice] = 'HostelFacility was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_facility
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelFacility.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
