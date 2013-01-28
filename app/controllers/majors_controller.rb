# -*- encoding : utf-8 -*-
class MajorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @major_pages, @majors = paginate :majors, :per_page => 10
  end

  def show
    @major = Major.find(params[:id])
  end

  def new
    @major = Major.new
  end

  def create
    @major = Major.new(params[:major])
    if @major.save
      flash[:notice] = 'Major was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @major = Major.find(params[:id])
  end

  def update
    @major = Major.find(params[:id])
    if @major.update_attributes(params[:major])
      flash[:notice] = 'Major was successfully updated.'
      redirect_to :action => 'show', :id => @major
    else
      render :action => 'edit'
    end
  end

  def destroy
    Major.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
