# -*- encoding : utf-8 -*-
class HostelPoliciesController < ApplicationController
  layout "standard-layout"
  def initialize
	@policy_items = PolicyItem.find(:all, :order=>"id")
  end
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_policy_pages, @hostel_policies = paginate :hostel_policies, :per_page => 10
  end

  def show
    @hostel_policy = HostelPolicy.find(params[:id])
  end

  def new
    @hostel_policy = HostelPolicy.new
  end

  def create
    policy_item_id = params[:policy_item_id]
    desc1 = params[:desc1]
    desc2 = params[:desc2]
    
    jum = policy_item_id.size
            
    x=0   
    jum.times do
      id = policy_item_id[x]
      one = desc1[x]
      two = desc2[x]
      
      @hostel_policy = HostelPolicy.new(params[:hostel_policy])
      @hostel_policy.policy_item_id = id
      @hostel_policy.description = one
      @hostel_policy.description2 = two
      @hostel_policy.save
      
      x=x+1
    end
    
    if @hostel_policy.save
      flash[:notice] = 'Polisi Asrama telah ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    #@hostel_policy = HostelPolicy.find(params[:id])
    @hostel_policy = HostelPolicy.find(:all, :order=>"id")
  end

  def update
    cid = params[:tid]
    policy_item_id = params[:policy_item_id]
    desc1 = params[:desc1]
    desc2 = params[:desc2]
    
    jum = policy_item_id.size
    x=0   
    jum.times do
      vid = cid[x]
      id = policy_item_id[x]
      one = desc1[x]
      two = desc2[x]
      
      @hostel_policy = HostelPolicy.find_by_id(vid)
      @hostel_policy.policy_item_id = id
      @hostel_policy.description = one
      @hostel_policy.description2 = two
      @hostel_policy.update_attributes(params[:hostel_policy])
      
      x=x+1
    end
    
    if @hostel_policy.update_attributes(params[:hostel_policy])
      flash[:notice] = 'HostelPolicy was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelPolicy.find(params[:id]).destroy
      redirect_to :action => 'list'
  end
end
