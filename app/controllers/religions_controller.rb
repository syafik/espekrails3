# -*- encoding : utf-8 -*-
class ReligionsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @religion_pages, @religions = paginate :religions, :per_page => 20
  end

  def show
    @religion = Religion.find(params[:id])
  end

  def new
    @religion = Religion.new
  end

  def create
    @religion = Religion.new(params[:religion])
    if @religion.save
      flash[:notice] = 'Agama Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @religion = Religion.find(params[:id])
  end

  def update
    @religion = Religion.find(params[:id])
    if @religion.update_attributes(params[:religion])
      flash[:notice] = 'Agama Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @religion
    else
      render :action => 'edit'
    end
  end

  def destroy
    Religion.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
