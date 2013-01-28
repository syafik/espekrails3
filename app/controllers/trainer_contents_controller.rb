# -*- encoding : utf-8 -*-
class TrainerContentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @trainer_content_pages, @trainer_contents = paginate :trainer_contents, :per_page => 10
  end

  def show
    @trainer_content = TrainerContent.find(params[:id])
  end

  def new
    @trainer_content = TrainerContent.new
  end

  def create
    @trainer_content = TrainerContent.new(params[:trainer_content])
    if @trainer_content.save
      flash[:notice] = 'TrainerContent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @trainer_content = TrainerContent.find(params[:id])
  end

  def update
    @trainer_content = TrainerContent.find(params[:id])
    if @trainer_content.update_attributes(params[:trainer_content])
      flash[:notice] = 'TrainerContent was successfully updated.'
      redirect_to :action => 'show', :id => @trainer_content
    else
      render :action => 'edit'
    end
  end

  def destroy
    TrainerContent.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
