# -*- encoding : utf-8 -*-
class QuizAnswersController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_answer_pages, @quiz_answers = paginate :quiz_answer, :per_page => 10
  end

  def show
    @quiz_answer = QuizAnswer.find(params[:id])
  end

  def show_answer1
    @profile = Profile.find(params[:id])
    @quiz = Quiz.find(params[:quiz_id])
    #@quiz_questions = QuizQuestion.find(:all, :conditions => ["quiz_id = ?", "#{params[:quiz_id]}"], :order => "id")
  end

  def show_answer2
    @profile = Profile.find(params[:id])
    @quiz = Quiz.find(params[:quiz_id])
    #@quiz_questions = QuizQuestion.find(:all, :conditions => ["quiz_id = ?", "#{params[:quiz_id]}"], :order => "id")
    @check = QuizAnswer.find(:first, :conditions=> "quiz_id='#{@quiz.id}' AND profile_id = '#{@profile.id}' AND fraction = 'before'", :order => "quiz_question_id")
  end

  def show_answer3
    @course_application = CourseApplication.find(params[:id])
    @check = QuizAnswer.find(:first, :conditions=> "course_application_id='#{@course_application.id}' AND fraction = 'before'")
    @profile = Profile.find(@check.profile_id) if @check
    @quiz = Quiz.find(@check.quiz_id) if @check
    #@quiz_questions = QuizQuestion.find(:all, :conditions => ["quiz_id = ?", "#{@quiz.id}"], :order => "id")
  end
  
  def tambah
    @quiz = Quiz.find(params[:id]) if params[:id]
    @profile = Profile.find(params[:profile_id])
    @quiz.quiz_questions.size.times do |n|
      y = n + 1
      next if params["quiz_answer"]["#{y}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{y}"])
      @quiz_answer.update_attributes(:profile_id => "#{@profile.id}")
      @quiz_answer.update_attributes(:fraction => "before")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Diterima'
      redirect_to :controller => 'quiz_questions', :action => 'list_peserta', :id => @quiz.id
    else
      render :action => 'show_answer2'
    end
  end
  
  def tambah_update
    @quiz = Quiz.find(params[:id]) if params[:id]
    @profile = Profile.find(params[:profile_id])
    @test = QuizAnswer.find(:all, :conditions=> "quiz_id='#{@quiz.id}' AND profile_id = '#{@profile.id}' AND fraction = 'before'")
      for q in @test
        q.destroy
      end
    @quiz.quiz_questions.size.times do |n|
      y = n + 1
      next if params["quiz_answer"]["#{y}"].blank?
      @quiz_answer = QuizAnswer.create(params["quiz_answer"]["#{y}"])
      @quiz_answer.update_attributes(:profile_id => "#{@profile.id}")
      @quiz_answer.update_attributes(:fraction => "before")
    end
    if @quiz_answer.save
      flash[:notice] = 'Semua Jawapan Telah Dikemaskini'
      redirect_to :controller => 'quiz_questions', :action => 'list_peserta', :id => @quiz.id
    else
      render :action => 'show_answer2'
    end
  end
  
  def new
    @quiz_question = QuizQuestion.find(params[:id]) if params[:id]
    @quiz = Quiz.find(@quiz_question.quiz_id)
    @quiz_answer = QuizAnswer.new
  end

  def create
    @quiz_answer = QuizAnswer.new(params[:quiz_answer])
    @quiz_question = QuizQuestion.find(@quiz_answer.quiz_question_id)
    @quiz = Quiz.find(@quiz_question.quiz_id)
    if @quiz_answer.save
      flash[:notice] = 'Jawapan Telah Ditambah'
      redirect_to :controller => 'quiz_questions', :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_answer = QuizAnswer.find(params[:id])
  end

  def update
    @quiz_answer = QuizAnswer.find(params[:id])
    if @quiz_answer.update_attributes(params[:quiz_answer])
      flash[:notice] = 'QuizAnswer was successfully updated.'
      redirect_to :action => 'show', :id => @quiz_answer
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuizAnswer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
