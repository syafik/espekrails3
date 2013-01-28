# -*- encoding : utf-8 -*-
class QuestionTemplatesController < ApplicationController
  layout "standard-layout"
  
  def index
    list
    render :action => 'list'
  end

  def list
    @question_template_pages, @question_templates = paginate :question_template, :per_page => 100
  end

  def course
    @course_implementations = CourseImplementation.find_all
    @question_template_pages, @question_templates = paginate :question_template, :per_page => 100, :order_by => "description"
  end
  
  def student
    @students = CourseApplication.find(:all, :conditions=>"profile_id = #{session[:user].profile_id} AND student_status_id=5")
	@courses = Course.find(:all, :order=>"name")
  end
  
  def show
    @question_template = QuestionTemplate.find(params[:id])
  end

  def new
    @question_template = QuestionTemplate.new
  end
  
  def new_course
    @course_implementations = CourseImplementation.find_all
    @question_template = QuestionTemplate.find(params[:id])
  end
  
  def create
    @question_template = QuestionTemplate.new(params[:question_template])
    if @question_template.save
      flash[:notice] = 'Template Borang Penilaian Telah Ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def create_course
    @question_template = QuestionTemplate.find(params[:id])
    @question_template.course_implementations = CourseImplementation.find(params[:course_implementation_ids]) if @params[:course_implementation_ids]
    if @question_template.save
      flash[:notice] = 'Borang Penilaian Kursus Telah Ditambah.'
      redirect_to :action => 'course'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @question_template = QuestionTemplate.find(params[:id])
  end

  def update
    @question_template = QuestionTemplate.find(params[:id])
    if @question_template.update_attributes(params[:question_template])
      flash[:notice] = 'Template Borang Penilaian Telah Dikemaskinikan.'
      redirect_to :action => 'show', :id => @question_template
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuestionTemplate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
