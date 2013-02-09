# -*- encoding : utf-8 -*-
class QuestionSectionsController < ApplicationController
  layout "standard-layout"
  def initialize
    @question_types = QuestionType.find(:all, :order=>"description")
  end
  
  def index
    redirect_to :action => 'list'
  end

  def list
    @question_sections = QuestionSection.paginate(:per_page => 50, :page => params[:page]).order("description ASC")
    render layout: "standard-layout"
  end

  def show
    @question_section = QuestionSection.find(params[:id])
    render layout: "standard-layout"
  end

  def new
    @question_section = QuestionSection.new
    render layout: "standard-layout"
  end

  def create
    @question_section = QuestionSection.new(params[:question_section])
    if @question_section.save
      flash[:notice] = 'Seksyen Borang Penilaian Telah Ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @question_section = QuestionSection.find(params[:id])
    render layout: "standard-layout"
  end

  def update
    @question_section = QuestionSection.find(params[:id])
    if @question_section.update_attributes(params[:question_section])
      flash[:notice] = 'Sekysen Borang Penilaian Telah Dikemaskinikan.'
      redirect_to :action => 'show', :id => @question_section
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuestionSection.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
