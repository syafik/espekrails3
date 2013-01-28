# -*- encoding : utf-8 -*-
class QuizSubjectivesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_subjective_pages, @quiz_subjectives = paginate :quiz_subjective, :per_page => 10
  end

  def show
    @quiz_subjective = QuizSubjective.find(params[:id])
  end

  def new
    @quiz_question = QuizQuestion.find(params[:id]) if params[:id]
    @quiz = Quiz.find(@quiz_question.quiz_id)
    @quiz_subjective = QuizSubjective.new
  end

  def create
    @quiz_subjective = QuizSubjective.new(params[:quiz_subjective])
    @quiz_question = QuizQuestion.find(@quiz_subjective.quiz_question_id)
    @quiz = Quiz.find(@quiz_question.quiz_id)
    if @quiz_subjective.save
      flash[:notice] = 'Skema Jawapan Subjektif Telah Ditambah'
      redirect_to :controller => 'quiz_questions', :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_subjective = QuizSubjective.find(params[:id])
  end

  def update
    @quiz_subjective = QuizSubjective.find(params[:id])
    if @quiz_subjective.update_attributes(params[:quiz_subjective])
      flash[:notice] = 'QuizSubjective was successfully updated.'
      redirect_to :action => 'show', :id => @quiz_subjective
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuizSubjective.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
