# -*- encoding : utf-8 -*-
class TitlesController < ApplicationController
	layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @title_pages, @titles = paginate :titles, :per_page => 10
  end

  def show
    @title = Title.find(params[:id])
  end

  def new
    @title = Title.new
  end

  def create
    @title = Title.new(params[:title])
    if @title.save
      flash[:notice] = 'Gelaran Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @title = Title.find(params[:id])
  end

  def update
    @title = Title.find(params[:id])
    if @title.update_attributes(params[:title])
      flash[:notice] = 'Gelaran Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @title
    else
      render :action => 'edit'
    end
  end

  def destroy
    Title.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
