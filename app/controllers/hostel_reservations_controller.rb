# -*- encoding : utf-8 -*-
class HostelReservationsController < ApplicationController
  layout "standard-layout"
  
  def initialize
	@hostel_types = HostelType.find(:all, :order=>"id")
	@hostels = Hostel.find(:all, :order=>"id")
	@profiles = Profile.find(:all, :order=>"id")
	#@hostel_policies = HostelPolicy.find(:all, :order=>"id")
	@planning_years = HostelReservation.find_by_sql("SELECT distinct extract(year from created_on)as year from hostel_reservations ORDER BY year DESC")
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_reservation_pages, @hostel_reservations = paginate :hostel_reservations, :per_page => 10
  end

  def show
    @hostel_reservation = HostelReservation.find(params[:id])
    @profile = Profile.find(@hostel_reservation.profile_id)
    @hostel_type = HostelType.find(@hostel_reservation.hostel_type_id)
  end

  def new
    @username = session[:user].login
    @vid = session[:user].profile_id
    @profile = Profile.find(@vid)
    @hostel_reservation = HostelReservation.new
    @policy = HostelPolicy.find_by_sql("SELECT hostel_policies.description FROM hostel_policies INNER JOIN policy_items ON policy_items.id = policy_item_id WHERE code = 'K'")
    for @po in @policy
      @kongsi =@po.description
    end
    @policyE = HostelPolicy.find_by_sql("SELECT hostel_policies.description, hostel_policies.description2 FROM hostel_policies INNER JOIN policy_items ON policy_items.id = policy_item_id WHERE code = 'E'")
    for @poe in @policyE
      @edesc1 =@poe.description
      @edesc2 =@poe.description2
    end
    @policyD = HostelPolicy.find_by_sql("SELECT hostel_policies.description, hostel_policies.description2 FROM hostel_policies INNER JOIN policy_items ON policy_items.id = policy_item_id WHERE code = 'D'")
    for @pod in @policyD
      @ddesc1 =@pod.description
      @ddesc2 =@pod.description2
    end
  end

  def create
    @hostel_reservation = HostelReservation.new(params[:hostel_reservation])
    @hostel_reservation.chkin_date = params[:chkin_date2]+"/"+params[:chkin_date1]+"/"+params[:chkin_date3]
    @hostel_reservation.chkout_date = params[:chkout_date2]+"/"+params[:chkout_date1]+"/"+params[:chkout_date3]
    
    if @hostel_reservation.save
      flash[:notice] = 'Bilik berjaya ditempah.'
      redirect_to :action => 'detail', :id => @hostel_reservation.id
    else
      @username = session[:user].login
      @vid = session[:user].profile_id
      @profile = Profile.find(@vid)
      render :action => 'new', :@vid => @vid
    end
  end

  def edit
    @hostel_reservation = HostelReservation.find(params[:id])
  end

  def update
    @hostel_reservation = HostelReservation.find(params[:id])
    if @hostel_reservation.update_attributes(params[:hostel_reservation])
      flash[:notice] = 'HostelReservation was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_reservation
    else
      render :action => 'edit'
    end
  end
  
  def detail
    @hostel_reservation = HostelReservation.find(params[:id])
    @profile = Profile.find(@hostel_reservation.profile_id)
    @hostel_type = HostelType.find(@hostel_reservation.hostel_type_id)
  end

  def destroy
    HostelReservation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
