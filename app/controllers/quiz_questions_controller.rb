# -*- encoding : utf-8 -*-
class QuizQuestionsController < ApplicationController
  layout "standard-layout"

  def initialize
    @quiz_types = QuizType.find(:all, :order=>"description")
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @quiz_question_pages, @quiz_questions = paginate :quiz_question, :per_page => 100
  end
  
  def cetak_soalan
    list_soalan
  end

  def list_soalan
    @quiz = Quiz.find_by_id(params[:id]) if params[:id]
    @quiz_questions = @quiz.quiz_questions.paginate(:per_page => 100,:page => params[:page]).order("id asc")
    render layout: "standard-layout"
  end

  def list_peserta
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id)
    f = "ca.student_status_id"
  	s = Array.new
    s.push("#{f} = 5")
    s.push("#{f} = 8")
    t = s.join(" OR ")
	
	
    params[:orderby] = "personal_name" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]
    @arrow = params[:arrow]
  
    orderby = "name" if  @orderby == "personal_name"

    #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@quiz.course_implementation.id} AND (#{t})", :order=>'name asc')
    @students = CourseApplication.find_by_sql("select ca.* from profiles p, quizzes qq, course_implementations ci, course_applications ca where p.id = ca.profile_id and ca.course_implementation_id = ci.id and ci.id = qq.course_implementation_id and qq.id=#{@quiz.id} and (#{t})order by p.#{orderby} #{@arrow}")

    #@quiz_answers = QuizAnswer.find(:all, :conditions => ["quiz_question_id = ?", "#{@quiz_question.id}"]) if @quiz_question

    #untuk pengiraan markah
    quiz_questions = QuizQuestion.find(:all, :conditions => "quiz_id = '#{@quiz.id}'")
    for qq in quiz_questions
      #     quiz_answers = QuizAnswer.find(:all, :conditions => ["quiz_question_id = ? and fraction = ?", "#{qq.id}","before"])
      quiz_answers = QuizAnswer.find(:all, :conditions => ["quiz_question_id = ?", "#{qq.id}"])
      for qa in quiz_answers
        if qq.quiz_type_id == 2
          qo = QuizObjective.find_by_quiz_question_id_and_answer_type_id("#{qq.id}","1")
          if qo
            if qo.id == qa.answer
              qa.update_attributes(:feedback => "1")
            else
              qa.update_attributes(:feedback => "0")
            end
          end
        else
          qa.update_attributes(:feedback => "0")
        end
      end
    end
  end

  def list_peserta2
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.find_by_quiz_id(@quiz.id)
    @quiz_answers = QuizAnswer.find(:all, :conditions => ["quiz_question_id = ? and fraction = ?", "#{@quiz_question.id}","after"]) if @quiz_question

    #untuk pengiraan markah
    quiz_questions = QuizQuestion.find(:all, :conditions => "quiz_id = '#{@quiz.id}'")
    for qq in quiz_questions
      quiz_answers = QuizAnswer.find(:all, :conditions => ["quiz_question_id = ? and fraction = ?", "#{qq.id}","after"])
      for qa in quiz_answers
        if qq.quiz_type_id == 2
          qo = QuizObjective.find(:first, :conditions => ["quiz_question_id = ? and answer_type_id = ?", "#{qq.id}", "1"])
          if qo
            if qa.answer == qo.answer
              #render :text => "#{qa.answer}" and return
              qa.update_attributes(:feedback => "1")
            else
              qa.update_attributes(:feedback => "0")
            end
          end
        else
          qa.update_attributes(:feedback => "0")
        end
      end
    end
  end

  def show
    @quiz_question = QuizQuestion.find(params[:id])
  end

  def copy_and_new
    edit
    @quiz_objective = QuizObjective.new
  end
  
  def copy_and_create
    create_obj
	end

  def new_obj
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.new
    @quiz_objective = QuizObjective.new
  end

  def create_obj
    @quiz = Quiz.find(params[:quiz_question][:quiz_id]) if params[:quiz_question][:quiz_id]
    @quiz_question = QuizQuestion.new(params[:quiz_question])

    if @quiz_question.save
      5.times do |n|
        next if params[:quiz_objective][n.to_s][:answer].blank?
        @quiz_objective = QuizObjective.create(params[:quiz_objective][n.to_s])
        @quiz_objective.quiz_question = @quiz_question
        @quiz_objective.save
        #@quiz_objective.quiz_question_id = @quiz_question.id
      end
      flash[:notice] = 'Soalan Objektif Telah Berjaya Ditambah.'
      redirect_to :controller => 'quiz_questions', :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'new_obj'
    end
  end

  def new
    @quiz = Quiz.find(params[:id]) if params[:id]
    @quiz_question = QuizQuestion.new
  end

  def create
    @quiz_question = QuizQuestion.new(params[:quiz_question])
    if @quiz_question.save
      flash[:notice] = 'Soalan Telah Berjaya Ditambah.'
      if @quiz_question.quiz_type_id == 1
        redirect_to :controller => 'quiz_truefalses', :action => 'new', :id => @quiz_question.id
      elsif @quiz_question.quiz_type_id == 3
        redirect_to :controller => 'quiz_subjectives', :action => 'new', :id => @quiz_question.id
      else
        redirect_to :controller => 'quiz_objectives', :action => 'new', :id => @quiz_question.id
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz_question = QuizQuestion.find(params[:id])
    @quiz = Quiz.find(@quiz_question.quiz_id)
    if @quiz_question.quiz_type_id == 1
      @quiz_truefalse = QuizTruefalse.find_by_quiz_question_id(@quiz_question.id)
    elsif @quiz_question.quiz_type_id == 3
      @quiz_subjective = QuizSubjective.find_by_quiz_question_id(@quiz_question.id)
    else
      @quiz_objective = QuizObjective.find_by_quiz_question_id(@quiz_question.id)
    end
  end

  def update
    @quiz_question = QuizQuestion.find(params[:id])
    @quiz = Quiz.find(@quiz_question.quiz_id)
    if @quiz_question.quiz_type_id == 1
      @quiz_truefalse = QuizTruefalse.find_by_quiz_question_id(@quiz_question.id)
      @quiz_truefalse.update_attributes(params[:quiz_truefalse])
    elsif @quiz_question.quiz_type_id == 3
      @quiz_subjective = QuizSubjective.find_by_quiz_question_id(@quiz_question.id)
      @quiz_subjective.update_attributes(params[:quiz_subjective])
    else
      for q in @quiz_question.quiz_objectives
        #render :text => q.answer_tyid and return
        if !params['quiz_objective']['answer_type_id']
          q.answer_type_id = 0
        end
        q.update_attributes(params["quiz_objective"]["#{q.id}"])
      end
      #@quiz_objective = QuizObjective.find_by_quiz_question_id(@quiz_question.id)
      #@quiz_objective.update_attributes(params[:quiz_objective])
    end
    if @quiz_question.update_attributes(params[:quiz_question])
      flash[:notice] = 'Soalan Telah Dikemaskinikan.'
      redirect_to :action => 'list_soalan', :id => @quiz.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    @quiz_question = QuizQuestion.find(params[:id])
    @quiz = Quiz.find(@quiz_question.quiz_id)
    QuizQuestion.find(params[:id]).destroy
    redirect_to :action => 'list_soalan', :id => @quiz.id
  end
end
