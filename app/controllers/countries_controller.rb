# -*- encoding : utf-8 -*-
class CountriesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @country_pages, @countries = paginate :countries, :per_page => 20
  end

  def show
    @country = Country.find(params[:id])
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:notice] = 'Negara Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = 'Negara Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @country
    else
      render :action => 'edit'
    end
  end

  def destroy
    Country.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
