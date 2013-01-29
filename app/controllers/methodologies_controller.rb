# -*- encoding : utf-8 -*-
class MethodologiesController < ApplicationController
#  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @methodology_pages, @methodologies = Methodology.paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @methodology = Methodology.find(params[:id])
  end

  def new
    @methodology = Methodology.new
  end

  def create
    @methodology = Methodology.new(params[:methodology])
    if @methodology.save
      flash[:notice] = 'Methodology was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def new_popup
    @methodology = Methodology.new
  end
  
  def create_popup
    @methodology = Methodology.new(params[:methodology])
    if @methodology.save
      #flash[:notice] = 'Methodology was successfully created.'
      #redirect_to :action => 'list'
    else
      #render :action => 'new'
    end
  end

  def edit
    @methodology = Methodology.find(params[:id])
  end

  def update
    @methodology = Methodology.find(params[:id])
    if @methodology.update_attributes(params[:methodology])
      flash[:notice] = 'Methodology was successfully updated.'
      redirect_to :action => 'show', :id => @methodology
    else
      render :action => 'edit'
    end
  end

  def destroy
    Methodology.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
