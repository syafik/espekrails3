# -*- encoding : utf-8 -*-
class FacilityTypesController < ApplicationController
  layout "standard-layout"
  def initialize
    @facility_types = FacilityType.find(:all, :order=>"code")
    @facility_category = FacilityCategory.find(:all, :order=>"id")
  end
  
  def index
    list
    render :action => 'list', :layout => "standard-layout"
  end

  def list
    #render_text FacilityCategory.id and return
    @facility_types = FacilityType.paginate(:per_page => 100, :page => params[:page]).order('code ASC')
    #@facility_type_sort = FacilityType.find(:all, :conditions=>"facility_category_id=#{FacilityCategory.id}")
  end

  def show
    @facility_type = FacilityType.find(params[:id])
    render layout: "standard-layout"
  end

  def new
    @facility_type = FacilityType.new
    #@facility_category = FacilityCategory.new
    @facility_category = FacilityCategory.find(:all, :order=>"id")
    render layout: "standard-layout"
  end

  def create
    @facility_type = FacilityType.new(params[:facility_type])
    if @facility_type.save
      flash[:notice] = 'Jenis sumber kemudahan telah ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @facility_type = FacilityType.find(params[:id])
    @facility_category = FacilityCategory.find(:all, :order=>"id")
    render layout: "standard-layout"
  end

  def update
    @facility_type = FacilityType.find(params[:id])
    if @facility_type.update_attributes(params[:facility_type])
      flash[:notice] = 'Jenis sumber kemudahan telah dikemaskini.'
      #redirect_to :action => 'show', :id => @facility_category
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    FacilityType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
