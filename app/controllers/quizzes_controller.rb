# -*- encoding : utf-8 -*-
class QuizzesController < ApplicationController
  layout "standard-layout"
  
  def initialize
    @course_implementations = CourseImplementation.find(:all, :order=>"code")
  end

  def index
    #    list
    redirect_to :action => 'list'
  end

  def list
    @course_departments = CourseDepartment.find(:all, :order=>"id")
    
    if !params[:course_department_id]
      sch_dept = nil
    else
      sch_dept = "AND quizzes.course_department_id = "+params[:course_department_id]
    end

    @quizzes = Quiz.find_by_sql("select * from course_implementations join quizzes on quizzes.course_implementation_id=course_implementations.id #{sch_dept} order by quizzes.timeopen desc")
    #@quiz_pages, @quizzes = paginate :quizzes, :per_page => 100, :order_by => "updated_on DESC"
    render :layout => "standard-layout"
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
    today = Time.new
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    tomorrow = today + (60 * 60)
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year

  end

  def create
    @quiz = Quiz.new(params[:quiz])
#    @quiz.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @quiz.timeopen = DateTime.parse("#{params[:year_check_in]}-#{params[:month_check_in]}-#{params[:day_check_in]} #{params[:hour_check_in]}:#{params[:minute_check_in]}")
#    @quiz.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    @quiz.timeclose = DateTime.parse("#{params[:year_check_out]}-#{params[:month_check_out]}-#{params[:day_check_out]} #{params[:hour_check_out]}:#{params[:minute_check_out]}:00")
    
    if @quiz.save
      flash[:notice] = 'Ujian Telah Berjaya Disimpan'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @ci=CourseImplementation.find(@quiz.course_implementation_id)
    if @quiz.timeopen != nil
      today = @quiz.timeopen
    else
      today = Time.new
    end
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    if @quiz.timeclose != nil
      tomorrow = @quiz.timeclose
    else
      tomorrow = today + (60 * 60)
    end
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
    
  end

  def update
    @quiz = Quiz.find(params[:id])
    @ci=CourseImplementation.find(@quiz.course_implementation_id)
    @quiz.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @quiz.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]
    
    if @quiz.update_attributes(params[:quiz])
      flash[:notice] = 'Ujian Telah Dikemaskinikan'
      redirect_to :action => 'shiken_ichiran', :id=>@quiz.course_implementation_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    Quiz.find(params[:id]).destroy
    redirect_to :action => 'shiken_ichiran', :id=>@quiz.course_implementation_id
  end
  
  def shiken_ichiran
  	@ci = CourseImplementation.find(params[:id])
    render :layout => "standard-layout"
  end
  
  def shinki
  	new
    @ci=CourseImplementation.find(params[:id])
    render :layout => "standard-layout"
  end

  def hozon
    @quiz = Quiz.new(params[:quiz])
     @quiz.timeopen = DateTime.parse("#{params[:year_check_in]}-#{params[:month_check_in]}-#{params[:day_check_in]} #{params[:hour_check_in]}:#{params[:minute_check_in]}")
    @quiz.timeclose = DateTime.parse("#{params[:year_check_out]}-#{params[:month_check_out]}-#{params[:day_check_out]} #{params[:hour_check_out]}:#{params[:minute_check_out]}:00")
    @quiz.created_on = "#{params[:year_create]}-#{params[:month_create]}-#{params[:day_create]}"
    
    if @quiz.save
      flash[:notice] = 'Ujian Telah Berjaya Disimpan'
      redirect_to :action => 'shiken_ichiran', :id=> params[:quiz][:course_implementation_id]
    else
      render :action => 'shinki'
    end
  end
  
end
