# -*- encoding : utf-8 -*-
class ScaleTypesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @scale_type_pages, @scale_types = paginate :scale_types, :per_page => 50
  end

  def show
    @scale_type = ScaleType.find(params[:id])
  end

  def new
    @scale_type = ScaleType.new
  end

  def create
    @scale_type = ScaleType.new(params[:scale_type])
    if @scale_type.save
      flash[:notice] = 'Jenis Skala Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @scale_type = ScaleType.find(params[:id])
  end

  def update
    @scale_type = ScaleType.find(params[:id])
    if @scale_type.update_attributes(params[:scale_type])
      flash[:notice] = 'Jenis Skala Telah Dikemaskini'
      redirect_to :action => 'show', :id => @scale_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    ScaleType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
