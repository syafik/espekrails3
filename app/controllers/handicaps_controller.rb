# -*- encoding : utf-8 -*-
class HandicapsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @handicap_pages, @handicaps = paginate :handicap, :per_page => 10
  end

  def show
    @handicap = Handicap.find(params[:id])
  end

  def new
    @handicap = Handicap.new
  end

  def create
    @handicap = Handicap.new(params[:handicap])
    if @handicap.save
      flash[:notice] = 'Jenis Kecacatan Telah Ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @handicap = Handicap.find(params[:id])
  end

  def update
    @handicap = Handicap.find(params[:id])
    if @handicap.update_attributes(params[:handicap])
      flash[:notice] = 'Jenis Kecacatan Telah Dikemaskinikan.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Handicap.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
