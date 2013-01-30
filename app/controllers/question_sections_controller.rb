# -*- encoding : utf-8 -*-
class QuestionSectionsController < ApplicationController
  layout "standard-layout"
  def initialize
    @question_types = QuestionType.find(:all, :order=>"description")
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @question_sections = QuestionSection.paginate(:per_page => 50, :page => params[:page]).order("description ASC")
  end

  def show
    @question_section = QuestionSection.find(params[:id])
  end

  def new
    @question_section = QuestionSection.new
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
