# -*- encoding : utf-8 -*-
class AcctStatusesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @acct_status_pages, @acct_statuses = paginate :acct_statuses, :per_page => 10
  end

  def show
    @acct_status = AcctStatus.find(params[:id])
  end

  def new
    @acct_status = AcctStatus.new
  end

  def create
    @acct_status = AcctStatus.new(params[:acct_status])
    if @acct_status.save
      flash[:notice] = 'AcctStatus was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @acct_status = AcctStatus.find(params[:id])
  end

  def update
    @acct_status = AcctStatus.find(params[:id])
    if @acct_status.update_attributes(params[:acct_status])
      flash[:notice] = 'AcctStatus was successfully updated.'
      redirect_to :action => 'show', :id => @acct_status
    else
      render :action => 'edit'
    end
  end

  def destroy
    AcctStatus.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
