# -*- encoding : utf-8 -*-
class QualificationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @qualification_pages, @qualifications = paginate :qualifications, :per_page => 10
  end

  def show
    @qualification = Qualification.find(params[:id])
  end

  def new
    @qualification = Qualification.new
  end

  def create
    @qualification = Qualification.new(params[:qualification])
    if @qualification.save
      flash[:notice] = 'Qualification was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @qualification = Qualification.find(params[:id])
  end

  def update
    @qualification = Qualification.find(params[:id])
    if @qualification.update_attributes(params[:qualification])
      flash[:notice] = 'Qualification was successfully updated.'
      redirect_to :action => 'show', :id => @qualification
    else
      render :action => 'edit'
    end
  end

  def destroy
    Qualification.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
