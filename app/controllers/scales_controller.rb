# -*- encoding : utf-8 -*-
class ScalesController < ApplicationController
  layout "standard-layout"
  
  def initialize
    @scale_types = ScaleType.find(:all, :order=>"description")
  end
  def index
    list
    render :action => 'list'
  end

  def list
    @scales = Scale.paginate(:per_page => 50, :page => params[:page]).order("rating ASC")
  end

  def show
    @scale = Scale.find(params[:id])
  end

  def new
    @scale = Scale.new
  end

  def create
    @scale = Scale.new(params[:scale])
    if @scale.save
      flash[:notice] = 'Skala Penilaian Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @scale = Scale.find(params[:id])
  end

  def update
    @scale = Scale.find(params[:id])
    if @scale.update_attributes(params[:scale])
      flash[:notice] = 'Skala Penilaian Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @scale
    else
      render :action => 'edit'
    end
  end

  def destroy
    Scale.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
