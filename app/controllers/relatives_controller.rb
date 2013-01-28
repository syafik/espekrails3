# -*- encoding : utf-8 -*-
class RelativesController < ApplicationController
#  def initialize
#    @relationships = Relationship.find_all
#    @races = Race.find_all
# end

  def index
    list
    render :action => 'list'
  end

  def list
    @relative_pages, @relatives = paginate :relatives, :per_page => 10
  end

  def show
    @relative = Relative.find(params[:id])
  end

  def new
    @relative = Relative.new
  end

  def create
    @relative = Relative.new(params[:relative])
    if @relative.save
      flash[:notice] = 'Relative was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @relative = Relative.find(params[:id])
  end

  def update
    @relative = Relative.find(params[:id])
    if @relative.update_attributes(params[:relative])
      flash[:notice] = 'Relative was successfully updated.'
      redirect_to :action => 'show', :id => @relative
    else
      render :action => 'edit'
    end
  end

  def destroy
    Relative.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
