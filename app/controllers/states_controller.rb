# -*- encoding : utf-8 -*-
class StatesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @state_pages, @states = paginate :states, :per_page => 20, :order_by => 'code'
  end

  def show
    @state = State.find(params[:id])
  end

  def new
    @state = State.new
  end

  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = 'Kod Negeri Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @state = State.find(params[:id])
  end

  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = 'Kod Negeri Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @state
    else
      render :action => 'edit'
    end
  end

  def destroy
    State.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
