# -*- encoding : utf-8 -*-
class PlaceContactsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @place_contact_pages, @place_contacts = paginate :place_contact, :per_page => 10
  end

  def show
    @place_contact = PlaceContact.find(params[:id])
  end

  def new
    @place_contact = PlaceContact.new
  end

  def create
    @place_contact = PlaceContact.new(params[:place_contact])
    if @place_contact.save
      flash[:notice] = 'PlaceContact was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @place_contact = PlaceContact.find(params[:id])
  end

  def update
    @place_contact = PlaceContact.find(params[:id])
    if @place_contact.update_attributes(params[:place_contact])
      flash[:notice] = 'PlaceContact was successfully updated.'
      redirect_to :action => 'show', :id => @place_contact
    else
      render :action => 'edit'
    end
  end

  def destroy
    PlaceContact.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
