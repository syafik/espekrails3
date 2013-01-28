# -*- encoding : utf-8 -*-
class AttendancesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @attendance_pages, @attendances = paginate :attendance, :per_page => 10
  end

  def show
    @attendance = Attendance.find(params[:id])
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(params[:attendance])
    if @attendance.save
      flash[:notice] = 'Attendance was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(params[:attendance])
      flash[:notice] = 'Attendance was successfully updated.'
      redirect_to :action => 'show', :id => @attendance
    else
      render :action => 'edit'
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
