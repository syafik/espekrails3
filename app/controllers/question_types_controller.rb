# -*- encoding : utf-8 -*-
class QuestionTypesController < ApplicationController
  layout "standard-layout"
  def index
    list
    render :action => 'list'
  end

  def list
    @question_types = QuestionType.paginate(:per_page => 10, :page => params[:page]).order('description ASC')
  end

  def show
    @question_type = QuestionType.find(params[:id])
  end

  def new
    @question_type = QuestionType.new
  end

  def create
    @question_type = QuestionType.new(params[:question_type])
    if @question_type.save
      flash[:notice] = 'Jenis Soalan Telah Ditambah'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @question_type = QuestionType.find(params[:id])
  end

  def update
    @question_type = QuestionType.find(params[:id])
    if @question_type.update_attributes(params[:question_type])
      flash[:notice] = 'Jenis Soalan Telah Dikemaskinikan'
      redirect_to :action => 'show', :id => @question_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuestionType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
