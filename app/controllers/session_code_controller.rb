# -*- encoding : utf-8 -*-
class SessionCodeController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @session_code = SessionCode.paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @session_code = SessionCode.find(params[:id])
  end

  def new
    @session_code = SessionCode.new
  end

  def create
    @session_code = SessionCode.new(params[:session_code])
    if @session_code.save
      flash[:notice] = 'Sesi was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @session_code = SessionCode.new
  end
  
  def create_popup
    @session_code = SessionCode.new(params[:session_code])
    if @session_code.save
      #flash[:notice] = 'Sesi was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end

  def edit
    @session_code = SessionCode.find(params[:id])
  end

  def update
    @session_code = SessionCode.find(params[:id])
    if @session_code.update_attributes(params[:session_code])
      flash[:notice] = 'Sesi was successfully updated.'
      redirect_to :action => 'show', :id => @session_code
    else
      render :action => 'edit'
    end
  end

  def destroy
    SessionCode.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
