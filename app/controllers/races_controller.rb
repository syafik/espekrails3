# -*- encoding : utf-8 -*-
class RacesController < ApplicationController
#  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @races = Race.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @race = Race.find(params[:id])
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      flash[:notice] = 'Bangsa Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @race = Race.find(params[:id])
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(params[:race])
      flash[:notice] = 'Bangsa Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @race
    else
      render :action => 'edit'
    end
  end

  def destroy
    Race.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
