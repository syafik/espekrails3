# -*- encoding : utf-8 -*-
class FacilityCategoriesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @facility_categories = FacilityCategory.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @facility_category = FacilityCategory.find(params[:id])
  end

  def new
    @facility_category = FacilityCategory.new
  end

  def create
  #render_text params[:facility_category] and return
    @facility_category = FacilityCategory.new(params[:facility_category])
    if @facility_category.save
      flash[:notice] = 'FacilityCategory was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @facility_category = FacilityCategory.find(params[:id])
  end

  def update
    @facility_category = FacilityCategory.find(params[:id])
    if @facility_category.update_attributes(params[:facility_category])
      flash[:notice] = 'Kategori berjaya dikemaskini...'
      #redirect_to :action => 'show', :id => @facility_category
      redirect_to :action => 'list' #, :id => @facility_category
    else
      render :action => 'edit'
    end
  end

  def destroy
    FacilityCategory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
