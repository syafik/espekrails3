# -*- encoding : utf-8 -*-
class QuizTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_type_pages, @quiz_types = paginate :quiz_type, :per_page => 10
  end

  def show
    @quiz_type = QuizType.find(params[:id])
  end

  def new
    @quiz_type = QuizType.new
  end

  def create
    @quiz_type = QuizType.new(params[:quiz_type])
    if @quiz_type.save
      flash[:notice] = 'QuizType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_type = QuizType.find(params[:id])
  end

  def update
    @quiz_type = QuizType.find(params[:id])
    if @quiz_type.update_attributes(params[:quiz_type])
      flash[:notice] = 'QuizType was successfully updated.'
      redirect_to :action => 'show', :id => @quiz_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuizType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
