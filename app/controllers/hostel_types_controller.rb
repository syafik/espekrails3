# -*- encoding : utf-8 -*-
class HostelTypesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_types = HostelType.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @hostel_type = HostelType.find(params[:id])
  end

  def new
    @hostel_type = HostelType.new
  end

  def create
    @hostel_type = HostelType.new(params[:hostel_type])
    if @hostel_type.save
      flash[:notice] = 'HostelType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_type = HostelType.find(params[:id])
  end

  def update
    @hostel_type = HostelType.find(params[:id])
    if @hostel_type.update_attributes(params[:hostel_type])
      flash[:notice] = 'HostelType was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
