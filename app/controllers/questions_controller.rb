# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController
  layout "standard-layout"
  
  def initialize
    @question_types = QuestionType.find(:all, :order=>"description")
    @question_sections = QuestionSection.find(:all, :order=>"description")
    @question_templates = QuestionTemplate.find(:all, :order=>"description")
    @scale_types = ScaleType.find(:all, :order=>"id")
    @scales = Scale.find(:all, :order=>"rating")
  end

  def index
    rendirect_to :action => 'list'
  end

  def list
    @questions = Question.where("question_template_id = #{params[:id]}").paginate(:per_page => 100, :page => params[:page]).order("description ASC")
    render layout: "standard-layout"
  end

  def list_course
    @questions = Question.where("question_template_id = #{params[:id]}").paginate(:per_page => 100,:page => params[:page]).order("description ASC")
    render layout: "standard-layout"
  end
  
  def show
    @question = Question.find(params[:id])
    @question_section = QuestionSection.find(@question.question_section_id)
    @question_type = QuestionType.find(@question_section.question_type_id)
    render layout: "standard-layout"
  end

  def new
    @question = Question.new
    render layout: "standard-layout"
  end

  def create
    @question = Question.new(params[:question])
    @question.scale_types = ScaleType.find(params[:scale_type_ids]) if @params[:scale_type_ids]
    if @question.save
      flash[:notice] = 'Soalan Penilaian Telah Ditambah.'
      redirect_to :action => 'list', :id => @question.question_template_id
    else
      render :action => 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    render layout: "standard-layout"
  end

  def update
    @question = Question.find(params[:id])
    if !params['question']['scale_type_ids']
      @question.scale_types.clear
    end
    @question.scale_types = ScaleType.find(params[:scale_type_ids]) if @params[:scale_type_ids]
    if @question.update_attributes(params[:question])
      flash[:notice] = 'Soalan Penilaian Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @question
    else
      render :action => 'edit'
    end
  end

  def destroy
    Question.find(params[:id]).destroy
    redirect_to :controller => 'question_templates', :action => 'list'
  end
end
