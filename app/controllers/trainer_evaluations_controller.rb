# -*- encoding : utf-8 -*-
class TrainerEvaluationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @trainer_evaluation_pages, @trainer_evaluations = paginate :trainer_evaluations, :per_page => 10
  end

  def show
    @trainer_evaluation = TrainerEvaluation.find(params[:id])
  end

  def new
    @trainer_evaluation = TrainerEvaluation.new
  end

  def create
    @trainer_evaluation = TrainerEvaluation.new(params[:trainer_evaluation])
    if @trainer_evaluation.save
      flash[:notice] = 'TrainerEvaluation was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @trainer_evaluation = TrainerEvaluation.find(params[:id])
  end

  def update
    @trainer_evaluation = TrainerEvaluation.find(params[:id])
    if @trainer_evaluation.update_attributes(params[:trainer_evaluation])
      flash[:notice] = 'TrainerEvaluation was successfully updated.'
      redirect_to :action => 'show', :id => @trainer_evaluation
    else
      render :action => 'edit'
    end
  end

  def destroy
    TrainerEvaluation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
