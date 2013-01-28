# -*- encoding : utf-8 -*-
class HostelFixturesController < ApplicationController
  layout "standard-layout"
  
  def index
    list
    render :action => 'list'
  end

  def list
    @hostel_fixture_pages, @hostel_fixtures = paginate :hostel_fixture, :per_page => 100
  end

  def show
    @hostel_fixture = HostelFixture.find(params[:id])
  end

  def new
    @hostel_fixture = HostelFixture.new
  end

  def create
    @hostel_fixture = HostelFixture.new(params[:hostel_fixture])
    if @hostel_fixture.save
      flash[:notice] = 'HostelFixture was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hostel_fixture = HostelFixture.find(params[:id])
  end

  def update
    @hostel_fixture = HostelFixture.find(params[:id])
    if @hostel_fixture.update_attributes(params[:hostel_fixture])
      flash[:notice] = 'HostelFixture was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    HostelFixture.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
