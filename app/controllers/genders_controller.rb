# -*- encoding : utf-8 -*-
class GendersController < ApplicationController
#  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @genders = Gender.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @gender = Gender.find(params[:id])
  end

  def new
    @gender = Gender.new
  end

  def create
    @gender = Gender.new(params[:gender])
    if @gender.save
      flash[:notice] = 'Jantina Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @gender = Gender.find(params[:id])
  end

  def update
    @gender = Gender.find(params[:id])
    if @gender.update_attributes(params[:gender])
      flash[:notice] = 'Jantina Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @gender
    else
      render :action => 'edit'
    end
  end

  def destroy
    Gender.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
