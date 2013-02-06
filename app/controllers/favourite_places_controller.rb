# -*- encoding : utf-8 -*-
class FavouritePlacesController < ApplicationController
  layout "standard-layout"
  
  def initialize
    @states = State.all
  end
  
  def index
    rendirect_to  :action => 'list'
  end
  
  def list
    #@place_pages, @places = paginate :places, :per_page => 1000
#    @places = Place.find(:all)
    @places = Place.paginate(:per_page => 1000, :page => params[:page]).order("code ASC")
    render layout: "standard-layout"
  end
  
  def create
    #render :text => params[:tanah].size
    @dept_tanah = CourseDepartment.find(1)
    @dept_ukur  = CourseDepartment.find(2)
    @dept_tm    = CourseDepartment.find(3)
    
    FavouritePlace.find_by_sql("delete from favourite_places")
    
    if params[:tanah]
      params[:tanah].size.times do |i|
        p_id = params[:tanah][i]
        fp = FavouritePlace.find_by_sql("select * from favourite_places where course_department_id = 1 and place_id = #{p_id}")
        @dept_tanah.favourites.push(Place.find(p_id)) if fp.size == 0
      end
    end
    
    if params[:ukur]
      params[:ukur].size.times do |i|
        p_id = params[:ukur][i]
        fp = FavouritePlace.find_by_sql("select * from favourite_places where course_department_id = 2 and place_id = #{p_id}")
        @dept_ukur.favourites.push(Place.find(p_id)) if fp.size == 0
      end
    end
    
    if params[:tm]
      params[:tm].size.times do |i|
        p_id = params[:tm][i]
        fp = FavouritePlace.find_by_sql("select * from favourite_places where course_department_id = 3 and place_id = #{p_id}")
        @dept_tm.favourites.push(Place.find(p_id)) if fp.size == 0
      end
    end
    redirect_to :action => 'list'
  end
  
end
