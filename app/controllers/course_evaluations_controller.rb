# -*- encoding : utf-8 -*-
class CourseEvaluationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @course_evaluation_pages, @course_evaluations = paginate :course_evaluations, :per_page => 10
  end

  def show
    @course_evaluation = CourseEvaluation.find(params[:id])
  end

  def new
    @course_evaluation = CourseEvaluation.new
  end

  def create
    @course_evaluation = CourseEvaluation.new(params[:course_evaluation])
    if @course_evaluation.save
      flash[:notice] = 'CourseEvaluation was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @course_evaluation = CourseEvaluation.find(params[:id])
  end

  def update
    @course_evaluation = CourseEvaluation.find(params[:id])
    if @course_evaluation.update_attributes(params[:course_evaluation])
      flash[:notice] = 'CourseEvaluation was successfully updated.'
      redirect_to :action => 'show', :id => @course_evaluation
    else
      render :action => 'edit'
    end
  end

  def destroy
    CourseEvaluation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
