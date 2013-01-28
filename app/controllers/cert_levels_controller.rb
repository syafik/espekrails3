# -*- encoding : utf-8 -*-
class CertLevelsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @cert_level_pages, @cert_levels = paginate :cert_levels, :per_page => 10
  end

  def show
    @cert_level = CertLevel.find(params[:id])
  end

  def new
    @cert_level = CertLevel.new
  end

  def create
    @cert_level = CertLevel.new(params[:cert_level])
    if @cert_level.save
      flash[:notice] = 'CertLevel was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @cert_level = CertLevel.find(params[:id])
  end

  def update
    @cert_level = CertLevel.find(params[:id])
    if @cert_level.update_attributes(params[:cert_level])
      flash[:notice] = 'CertLevel was successfully updated.'
      redirect_to :action => 'show', :id => @cert_level
    else
      render :action => 'edit'
    end
  end

  def destroy
    CertLevel.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
