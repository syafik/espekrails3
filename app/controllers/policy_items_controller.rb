# -*- encoding : utf-8 -*-
class PolicyItemsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @policy_item_pages, @policy_items = paginate :policy_items, :per_page => 10
  end

  def show
    @policy_item = PolicyItem.find(params[:id])
  end

  def new
    @policy_item = PolicyItem.new
  end

  def create
    @policy_item = PolicyItem.new(params[:policy_item])
    if @policy_item.save
      flash[:notice] = 'PolicyItem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @policy_item = PolicyItem.find(params[:id])
  end

  def update
    @policy_item = PolicyItem.find(params[:id])
    if @policy_item.update_attributes(params[:policy_item])
      flash[:notice] = 'PolicyItem was successfully updated.'
      redirect_to :action => 'show', :id => @policy_item
    else
      render :action => 'edit'
    end
  end

  def destroy
    PolicyItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
