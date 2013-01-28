# -*- encoding : utf-8 -*-
class NationalityStatusesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @nationality_status_pages, @nationality_statuses = paginate :nationality_statuses, :per_page => 10
  end

  def show
    @nationality_status = NationalityStatus.find(params[:id])
  end

  def new
    @nationality_status = NationalityStatus.new
  end

  def create
    @nationality_status = NationalityStatus.new(params[:nationality_status])
    if @nationality_status.save
      flash[:notice] = 'NationalityStatus was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @nationality_status = NationalityStatus.find(params[:id])
  end

  def update
    @nationality_status = NationalityStatus.find(params[:id])
    if @nationality_status.update_attributes(params[:nationality_status])
      flash[:notice] = 'NationalityStatus was successfully updated.'
      redirect_to :action => 'show', :id => @nationality_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    NationalityStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
