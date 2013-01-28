# -*- encoding : utf-8 -*-
class QuizObjectivesController < ApplicationController
    layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_objective_pages, @quiz_objectives = paginate :quiz_objective, :per_page => 10
  end

  def show
    @quiz_objective = QuizObjective.find(params[:id])
  end

  def new
    @quiz_question = QuizQuestion.find(params[:id]) if params[:id]
    @quiz = Quiz.find(@quiz_question.quiz_id)
    @quiz_objective = QuizObjective.new
  end

  def create
    5.times do |n|
    next if params[:quiz_objective][n.to_s][:answer].blank?
    @quiz_objective = QuizObjective.create(params[:quiz_objective][n.to_s])
    @quiz_question = QuizQuestion.find(params[:quiz_objective][n.to_s][:quiz_question_id])
    @quiz = Quiz.find(@quiz_question.quiz_id)
    #@quiz_objective.quiz_question_id = @quiz_question.id
    end
    if @quiz_objective.save
      flash[:notice] = 'Skema Jawapan Objektif Telah Ditambah'
      redirect_to :controller => 'quiz_questions', :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_objective = QuizObjective.find(params[:id])
  end

  def update
    @quiz_objective = QuizObjective.find(params[:id])
    if @quiz_objective.update_attributes(params[:quiz_objective])
      flash[:notice] = 'QuizObjective was successfully updated.'
      redirect_to :action => 'show', :id => @quiz_objective
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuizObjective.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
