# -*- encoding : utf-8 -*-
class PlacesController < ApplicationController
  #  auto_complete_for :place, :name
  
  def initialize
    @states = State.all
  end
  
  def index
    redirect_to :action => "list", :layout => "standard-layout"
  end
  
  def list_kementerian
    @places = Place.where("place_type_id = '3'").paginate(:per_page => 100, :page => params[:page]).order("code ASC")
    render layout: "standard-layout"
  end

  def list
    @places = Place.where("place_type_id = '1'").paginate(:per_page => 100, :page => params[:page]).order("code ASC")
    render layout: "standard-layout"
  end

  def list_pejabat
    @places = Place.where("place_type_id = '2'").paginate(:per_page => 100, :page => params[:page]).order("code ASC")
    #	for place in @places
    #		if place.code =~ /0000/
    #			place.update_attributes(:place_type_id => "1")
    #		end
    #	end
    render layout: "standard-layout"
  end
  
  def search
     render layout: "standard-layout"
  end
  
  def search_by_name
    @places = Place.find(:all, :conditions => "name ILIKE '%#{params[:name]}%'", :order => "name")
  end
  
  def search_by_phone
    @places = Place.find(:all, :conditions => "phone ILIKE '%#{params[:phone]}%'", :order => "phone")
  end

  def search_by_state
    @places = Place.find(:all, :conditions => "state_id = '#{params[:state_id]}'", :order => "state_id")
  end
  
  def search_by_code
    @places = Place.find(:all, :conditions => "code ILIKE '%#{params[:code]}%'", :order => "code")
  end

  def show_kementerian
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end
  
  def show
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end

  def show_pejabat
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end
  
  def new_kementerian
    @place = Place.new
    @place_contact = PlaceContact.new
    render layout: "standard-layout"
  end
  
  def new
    @place = Place.new
    @place_contact = PlaceContact.new
    render layout: "standard-layout"
  end
  
  def new_pejabat
    @place = Place.new
    @place_contact = PlaceContact.new
    render layout: "standard-layout"
  end

  def create_kementerian
    @place = Place.new(params[:place])
    @place_contact = PlaceContact.new(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save
    @place.update_attributes(:place_type_id => "3")
    if @place.save
      flash[:notice] = 'Data kementerian telah disimpan.'
      redirect_to :action => 'list_kementerian'
    else
      render :action => 'new_kementerian'
    end
  end
  
  def create
    @place = Place.new(params[:place])
    @place_contact = PlaceContact.new(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save
    @place.update_attributes(:place_type_id => "1")
    if @place.save
      flash[:notice] = 'Data jabatan telah disimpan.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def create_pejabat
    @place = Place.new(params[:place])
    @place_contact = PlaceContact.new(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save
    @place.update_attributes(:place_type_id => "2")
    if @place.save
      flash[:notice] = 'Data pejabat telah disimpan.'
      redirect_to :action => 'list_pejabat'
    else
      render :action => 'new_pejabat'
    end
  end
  
  def edit_kementerian
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end
  
  def edit
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end

  def edit_pejabat
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    render layout: "standard-layout"
  end
  
  def update_kementerian
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    if @place_contact
      @place_contact.destroy
    end
    @place_contact = PlaceContact.create(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save

    if @place.update_attributes(params[:place])
      flash[:notice] = 'Data kementerian telah dikemaskini.'
      redirect_to :action => 'show_kementerian', :id => @place
    else
      render :action => 'edit_kementerian'
    end
  end
  
  def update
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    if @place_contact
      @place_contact.destroy
    end
    @place_contact = PlaceContact.create(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save

    if @place.update_attributes(params[:place])
      flash[:notice] = 'Data jabatan telah dikemaskini.'
      redirect_to :action => 'show', :id => @place
    else
      render :action => 'edit'
    end
  end

  def update_pejabat
    @place = Place.find(params[:id])
    @place_contact = PlaceContact.find_by_place_id(@place.id)
    if @place_contact
      @place_contact.destroy
    end
    @place_contact = PlaceContact.create(params[:place_contact])
    @place_contact.place = @place
    @place_contact.save

    if @place.update_attributes(params[:place])
      flash[:notice] = 'Data pejabat telah dikemaskini.'
      redirect_to :action => 'show_pejabat', :id => @place
    else
      render :action => 'edit_pejabat'
    end
  end
  
  def destroy_pejabat
    Place.find(params[:id]).destroy
    redirect_to :action => 'list_pejabat'
  end
  
  def destroy
    Place.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def destroy_kementerian
    Place.find(params[:id]).destroy
    redirect_to :action => 'list_kementerian'
  end
end
