# -*- encoding : utf-8 -*-
class SesiController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @sesi_pages, @sesi = paginate :sesi, :per_page => 20
  end

  def show
    @sesi = Sesi.find(params[:id])
  end

  def new
    @sesi = Sesi.new
  end

  def create
    @sesi = Sesi.new(params[:methodology])
    if @Sesi.save
      flash[:notice] = 'Sesi was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @sesi = Sesi.new
  end
  
  def create_popup
    @sesi = Sesi.new(params[:sesi])
    if @methodology.save
      #flash[:notice] = 'Sesi was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end

  def edit
    @sesi = Sesi.find(params[:id])
  end

  def update
    @sesi = Sesi.find(params[:id])
    if @sesi.update_attributes(params[:sesi])
      flash[:notice] = 'Sesi was successfully updated.'
      redirect_to :action => 'show', :id => @sesi
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sesi.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
