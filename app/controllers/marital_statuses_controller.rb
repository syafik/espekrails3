# -*- encoding : utf-8 -*-
class MaritalStatusesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @marital_statuses = MaritalStatus.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @marital_status = MaritalStatus.find(params[:id])
  end

  def new
    @marital_status = MaritalStatus.new
  end

  def create
    @marital_status = MaritalStatus.new(params[:marital_status])
    if @marital_status.save
      flash[:notice] = 'Status Perkahwinan Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @marital_status = MaritalStatus.find(params[:id])
  end

  def update
    @marital_status = MaritalStatus.find(params[:id])
    if @marital_status.update_attributes(params[:marital_status])
      flash[:notice] = 'Status Perkahwinan Telah Ditambah'
      redirect_to :action => 'show', :id => @marital_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    MaritalStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
