# -*- encoding : utf-8 -*-
class RelationshipsController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @relationships = Relationship.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @relationship = Relationship.find(params[:id])
  end

  def new
    @relationship = Relationship.new
  end

  def create
    @relationship = Relationship.new(params[:relationship])
    if @relationship.save
      flash[:notice] = 'Relationship was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @relationship = Relationship.find(params[:id])
  end

  def update
    @relationship = Relationship.find(params[:id])
    if @relationship.update_attributes(params[:relationship])
      flash[:notice] = 'Relationship was successfully updated.'
      redirect_to :action => 'show', :id => @relationship
    else
      render :action => 'edit'
    end
  end

  def destroy
    Relationship.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
