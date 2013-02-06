# -*- encoding : utf-8 -*-
class FacilitiesController < ApplicationController
  layout "standard-layout"
  def initialize
    @facility_categories = FacilityCategory.find(:all, :order=>"id")
    @facility_types = FacilityType.find(:all, :order=>"id")
    @facility_statuses = FacilityStatus.find(:all, :order=>"id")
  end
  
  def index
    redirect_to list_facilities_path
  end

  def list
    #@facilities = Facility.find(:all, :conditions=>"facility_category_id = #{params[:facility_category_id]}")
    params[:facility_category_id] = 0 if !params[:facility_category_id]  or params[:facility_category_id] == nil
    #@facilities = Facility.find_by_sql(" SELECT f.id,f.code,f.name,f.price,f.capacity,f.remark,fc.description as fc_desc,ft.description as ft_desc from facilities as f INNER JOIN facility_types as ft ON ft.id=f.facility_type_id INNER JOIN facility_categories as fc ON ft.facility_category_id=fc.id where f.facility_category_id=#{params[:facility_category_id]} ")
    @facilities = Facility.find(:all, :conditions=>"facility_category_id = #{params[:facility_category_id]} ")
    render layout: "standard-layout"
  end

  def show
    @facility = Facility.find(params[:id])
  end
  
  def newf
    @facility = Facility.new
  end

  def createf
    @facility = Facility.new(params[:facility])
    bils = params[:bilangan]
    
	#render :text=> params[:facility][:facility_type_id] and return
	@ftype = FacilityType.find(params[:facility][:facility_type_id])
    #@facility_category = @ftype.facility_category
    
    #render :text => @facility_category.code 
    querys = Facility.find_by_sql("SELECT * FROM facilities WHERE facility_category_id = #{@facility.facility_category_id}")
    jums = querys.size
    #render :text => jums 
        
    x=jums+1
    bils = bils.to_i
    bils.times do
      @facility = Facility.new(params[:facility])
      @facility.code = @ftype.code+""+x.to_s
	  #@facility.code = @facility_category.code+""+x.to_s
      @facility.save
      #render :text => @facility.code 
      x=x+1  
    end  
    
    if @facility.save
      flash[:notice] = 'Sumber kemudahan berjaya ditambah.'
	  redirect_to("/facilities/list?facility_category_id=#{@facility.facility_category_id}")
    else
      render :action => 'new'
    end
    
  end

  def new
    @facility = Facility.new
    render layout: "standard-layout"
  end

  def create
    @facility = Facility.new(params[:facility])
    if @facility.save
      flash[:notice] = 'Facility was successfully created.'
	  redirect_to("/facilities/list?facility_category_id=#{@facility.facility_category_id}")
    else
      render :action => 'new'
    end
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update_attributes(params[:facility])
      flash[:notice] = 'Sumber kemudahan berjaya dikemaskini.'
	  redirect_to("/facilities/list?facility_category_id=#{@facility.facility_category_id}")
    else
      render :action => 'edit'
    end
  end

  def destroy
    Facility.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
