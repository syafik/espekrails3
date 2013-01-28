# -*- encoding : utf-8 -*-
class HostelBlocksController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_block_pages, @hostel_blocks = paginate :hostel_blocks, :per_page => 10
  end

  def show
    @hostel_block = HostelBlock.find(params[:id])
  end

  def new
    @hostel_block = HostelBlock.new
  end

  def create
    @hostel_block = HostelBlock.new(params[:hostel_block])
    if @hostel_block.save
      flash[:notice] = 'HostelBlock was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_block = HostelBlock.find(params[:id])
  end

  def update
    @hostel_block = HostelBlock.find(params[:id])
    if @hostel_block.update_attributes(params[:hostel_block])
      flash[:notice] = 'HostelBlock was successfully updated.'
      redirect_to :action => 'show', :id => @hostel_block
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelBlock.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
