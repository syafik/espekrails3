# -*- encoding : utf-8 -*-
class QuizTruefalsesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_truefalse_pages, @quiz_truefalses = paginate :quiz_truefalse, :per_page => 10
  end

  def show
    @quiz_truefalse = QuizTruefalse.find(params[:id])
  end

  def new
    @quiz_question = QuizQuestion.find(params[:id]) if params[:id]
    @quiz = Quiz.find(@quiz_question.quiz_id)
    @quiz_truefalse = QuizTruefalse.new
  end

  def create
    @quiz_truefalse = QuizTruefalse.new(params[:quiz_truefalse])
    @quiz_question = QuizQuestion.find(@quiz_truefalse.quiz_question_id)
    @quiz = Quiz.find(@quiz_question.quiz_id)
    if @quiz_truefalse.save
      flash[:notice] = 'Skema Jawapan Betul/Salah Telah Ditambah'
      redirect_to :controller => 'quiz_questions', :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_truefalse = QuizTruefalse.find(params[:id])
  end

  def update
    @quiz_truefalse = QuizTruefalse.find(params[:id])
    if @quiz_truefalse.update_attributes(params[:quiz_truefalse])
      flash[:notice] = 'QuizTruefalse was successfully updated.'
      redirect_to :action => 'show', :id => @quiz_truefalse
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuizTruefalse.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
