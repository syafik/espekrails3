# -*- encoding : utf-8 -*-
class EmploymentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @employment_pages, @employments = paginate :employments, :per_page => 10
  end

  def show
    @employment = Employment.find(params[:id])
  end

  def new
    @employment = Employment.new
  end

  def create
    @employment = Employment.new(params[:employment])
    if @employment.save
      flash[:notice] = 'Employment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @employment = Employment.find(params[:id])
  end

  def update
    @employment = Employment.find(params[:id])
    if @employment.update_attributes(params[:employment])
      flash[:notice] = 'Employment was successfully updated.'
      redirect_to :action => 'show', :id => @employment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Employment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
