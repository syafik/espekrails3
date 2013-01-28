# -*- encoding : utf-8 -*-
class PlaceTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @place_type_pages, @place_types = paginate :place_types, :per_page => 10
  end

  def show
    @place_type = PlaceType.find(params[:id])
  end

  def new
    @place_type = PlaceType.new
  end

  def create
    @place_type = PlaceType.new(params[:place_type])
    if @place_type.save
      flash[:notice] = 'PlaceType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @place_type = PlaceType.find(params[:id])
  end

  def update
    @place_type = PlaceType.find(params[:id])
    if @place_type.update_attributes(params[:place_type])
      flash[:notice] = 'PlaceType was successfully updated.'
      redirect_to :action => 'show', :id => @place_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    PlaceType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
