# -*- encoding : utf-8 -*-
class EvaluationsController < ApplicationController
  layout "standard-layout"

  def initialize
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @evaluations = Evaluation.find(:all, :conditions => "course_implementation_id=#{params[:id]}")
  end

  def cetak_soalan
    @course_implementation = CourseImplementation.find(params[:id])
    @evaluation = @course_implementation.evaluations.first
    @topics = Topic.find(:all, :conditions => "course_implementation_id=#{@course_implementation.id}")
    @section_c_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=5")

  end

  def trainer_report
    @course_implementation = CourseImplementation.find(params[:evaluation_id])
    #@course_implementation = CourseImplementation.find(params[:id])
    @ev = @course_implementation.evaluations
    if @ev.size == 0
      render :text => "Soalan penilaian belum diset." and return
      if @ev.first.evaluation_questions.first.evaluation_answers.size == 0
        render :text => "Soalan penilaian telah diset, tetapi penilaian masih belum dimulakan." and return
        if @course_implementation.topics.size == 0
          render :text => "Tiada topic untuk kursus ini." and return
        end
      end
    end
    @topics = @course_implementation.topics
    @bil_penilai = @ev.first.evaluation_questions.first.evaluation_answers.size
  end

  def management_report
    @course_implementation = CourseImplementation.find(params[:evaluation_id])
    #@course_implementation = CourseImplementation.find(params[:id])
    @ev = @course_implementation.evaluations
    if @ev.size == 0
      render :text => "Soalan penilaian belum diset." and return
      if @ev.first.evaluation_questions.first.evaluation_answers.size == 0
        render :text => "Soalan penilaian telah diset, tetapi penilaian masih belum dimulakan." and return
        if @course_implementation.topics.size == 0
          render :text => "Tiada topic untuk kursus ini." and return
        end
      end
    end
    #@f_questions = EvaluationQuestion.find_all_by_evaluation_subsection_id(5)
    @f_questions = EvaluationQuestion.find(:all, :conditions => "evaluation_subsection_id=5 AND evaluation_id=#{@ev.first.id}")
    @bil_penilai = @f_questions.first.evaluation_answers.size
  end

  def facility_report
    @course_implementation = CourseImplementation.find(params[:evaluation_id])
    #@course_implementation = CourseImplementation.find(params[:id])
    @ev = @course_implementation.evaluations
    if @ev.size == 0
      render :text => "Soalan penilaian belum diset." and return
      if @ev.first.evaluation_questions.first.evaluation_answers.size == 0
        render :text => "Soalan penilaian telah diset, tetapi penilaian masih belum dimulakan." and return
        if @course_implementation.topics.size == 0
          render :text => "Tiada topic untuk kursus ini." and return
        end
      end
    end
    #@f_questions = EvaluationQuestion.find_all_by_evaluation_subsection_id(7)
    @f_questions = EvaluationQuestion.find(:all, :conditions => "evaluation_subsection_id=7 AND evaluation_id=#{@ev.first.id}")
    @bil_penilai = @f_questions.first.evaluation_answers.size
  end

  def content_report
    @course_implementation = CourseImplementation.find(params[:evaluation_id])
    #@course_implementation = CourseImplementation.find(params[:id])
    @ev = @course_implementation.evaluations
    if @ev.size == 0
      render :text => "Soalan penilaian belum diset." and return
      if @ev.first.evaluation_questions.first.evaluation_answers.size == 0
        render :text => "Soalan penilaian telah diset, tetapi penilaian masih belum dimulakan." and return
        if @course_implementation.topics.size == 0
          render :text => "Tiada topic untuk kursus ini." and return
        end
      end
    end
    @f_questions = EvaluationQuestion.find_all_by_evaluation_subsection_id(3)
    @f_questions = EvaluationQuestion.find(:all, :conditions => "evaluation_subsection_id=3 AND evaluation_id=#{@ev.first.id}")
    @bil_penilai = @f_questions.first.evaluation_answers.size
  end

  def comment_report
    @course_implementation = CourseImplementation.find(params[:evaluation_id])
    #@course_implementation = CourseImplementation.find(params[:id])
    @comments = @course_implementation.evaluation_comments
    #render :text=> @comments.size and return
  end

  def show
    @course_implementation = CourseImplementation.find(params[:id])

    if @course_implementation.evaluations.size == 0
      #create new evaluation for this course
      redirect_to :action => 'shinki', :id => params[:id] and return
    end
    @evaluation = @course_implementation.evaluations.first
    #@section_b_list = EvaluationQuestion.find(:all, :conditions=>"evaluation_id=#{@evaluation.id} and evaluation_type_id=4", :order=>"id asc")
    @topics = Topic.find(:all, :conditions => "course_implementation_id=#{@course_implementation.id}")
    #@section_b_list = EvaluationQuestion.find_by_sql("SELECT eq.*,etr.timetable_id FROM evaluation_questions as eq INNER JOIN evaluation_trainer_rankings as etr ON etr.evaluation_question_id=eq.id INNER JOIN timetables as tt ON tt.id=etr.timetable_id WHERE tt.course_implementation_id=#{params[:id]} order by tt.date,tt.time_start,id asc")
    @section_c_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=5")
  end

  def kaiseki
    show
  end

  def new
    @course_implementation = CourseImplementation.find(params[:id])
    @evaluation = Evaluation.new
    @evaluation.course_implementation = @course_implementation
    today = Time.new
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    tomorrow = today + (60 * 60)
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year
  end

  def reset
    r = ["evaluation_comments", "evaluation_answers", "evaluation_truefalses", "evaluation_rankings", "evaluation_trainer_rankings", "evaluation_questions", "evaluations"]
    r.size.times do |i|
      Profile.find_by_sql("delete from #{r[i]}")
    end
  end

  def shinki_2

    @course_implementation = CourseImplementation.find(params[:id])

    @evaluation = Evaluation.new
    @evaluation.course_implementation = @course_implementation
    @evaluation.name = "Penilaian Kursus(#{@course_implementation.code}"
    @evaluation.save

    #B
    @timetables = @course_implementation.timetables
    t_list = ["Isi Kandungan", "Penyampaian", "Kaitan Isi Kandungan dengan Kursus"]
    if @timetables.size > 0
      @timetables.size.times do |i|
        tt = @timetables[i]
        if tt.trainers.size > 0
          t_list.size.times do |j|
            eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                                :evaluation_section_id => 2,
                                                :evaluation_subsection_id => 2,
                                                :questiontext => t_list[j],
                                                :evaluation_type_id => 4)
            eval_quest.save!
            eval_trn_rnkg = EvaluationTrainerRanking.new(:timetable_id => tt.id,
                                                         :trainer_id => tt.trainers.first.id,
                                                         :evaluation_question_id => eval_quest.id,
                                                         :max_ranking => 5)
            eval_trn_rnkg.save!
          end

        end
      end
    end


    redirect_to :action => 'show', :id => @evaluation.course_implementation.id

  end

  def recreate
    @course_implementation = CourseImplementation.find(params[:id])
    @evaluation = Evaluation.find_by_course_implementation_id(params[:id])

    @can_recreate = 1
    for eq in @evaluation.evaluation_questions
      if eq.evaluation_answers.size > 0
        #"dah ada orang jawab ni takleh padam"
        @can_recreate = 0
      end
    end

    if @can_recreate = 1
      #delete first all questions then recreate
      for eq in @evaluation.evaluation_questions
        eq.evaluation_ranking.destroy if eq.evaluation_ranking!=nil
        eq.evaluation_trainer_ranking.destroy if eq.evaluation_trainer_ranking!=nil
        eq.evaluation_truefalse.destroy if eq.evaluation_truefalse!=nil
        #if eq.evaluation_truefalses.size > 0
        #	for trf in eq.evaluation_truefalses
        #		trf.destroy
        #	end
        #end
        eq.destroy
      end
    end
    @evaluation.destroy
    redirect_to :action => 'shinki', :id => params[:id]
    #render :text => @evaluation.evaluation_questions[0].evaluation_type.description and return

  end

  def shinki #create penilaian guna link dengan timetable

    @max_rating = 4; #have to take value from table 'scales'?

    @course_implementation = CourseImplementation.find(params[:id])

    @evaluation = Evaluation.new
    @evaluation.course_implementation = @course_implementation
    @evaluation.name = "Penilaian Kursus(#{@course_implementation.code})"
    @evaluation.created_by = session[:user].login
    @evaluation.save

    #B
    @timetables = @course_implementation.timetables
    #render :text=> @timetables.size and return
    t_list = ["Isi Kandungan", "Penyampaian", "Kaitan Isi Kandungan dengan Kursus"]
    if @timetables.size > 0
      @timetables.size.times do |i|
        tt = @timetables[i]
        if tt.trainers.size > 0
          t_list.size.times do |j|
            eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                                :evaluation_section_id => 2,
                                                :evaluation_subsection_id => 2,
                                                :questiontext => t_list[j],
                                                :created_by => session[:user].login,
                                                :evaluation_type_id => 4)
            eval_quest.save!
            eval_trn_rnkg = EvaluationTrainerRanking.new(:timetable_id => tt.id,
                                                         :trainer_id => tt.trainers.first.id,
                                                         :evaluation_question_id => eval_quest.id,
                                                         :created_by => session[:user].login,
                                                         :max_ranking => @max_rating)
            eval_trn_rnkg.save!
          end
        end
      end
    end

    #C
    skala = @max_rating
    a_list = ["Kesinambungan Topik-topik", "Penekanan kepada teori", "Penekanan kepada praktis"]
    b_list = ["Syarahan/Ceramah", "Kajian Kes", "Latihamal", "Perbincangan", "Lawatan"]
    c_list = ["Interaksi dengan peserta-peserta", "Kesediaan menerima maklumbalas", "Kesediaan bertindak atas maklumbalas"]
    all_list = [a_list, b_list, c_list]

    @c_subsections = EvaluationSection.find(3).evaluation_subsections
    subc_id = 3
    all_list.size.times do |h|
      all_list[h].size.times do |i|
        eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                            :evaluation_section_id => 3,
                                            :evaluation_subsection_id => subc_id,
                                            :questiontext => all_list[h][i],
                                            :created_by => session[:user].login,
                                            :evaluation_type_id => 5)
        eval_quest.save!
        eval_rnkg = EvaluationRanking.new(:evaluation_question_id => eval_quest.id,
                                          :max_ranking => skala,
                                          :created_by => session[:user].login)
        eval_rnkg.save!
      end
      subc_id = subc_id+1
    end

    #C true/false
    subc_id = 6
    d_list = ["Apakah anda telah mendapat faedah dari kursus ini?",
              "Adakah anda ingin memperakukan kursus ini kepada orang lain",
              "Adakah jangkamasa kursus bersesuaian"]
    d_list.size.times do |i|
      eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                          :evaluation_section_id => 3,
                                          :evaluation_subsection_id => subc_id,
                                          :questiontext => d_list[i],
                                          :created_by => session[:user].login,
                                          :evaluation_type_id => 6)
      eval_quest.save!
      eval_tf = EvaluationTruefalse.new(:evaluation_question_id => eval_quest.id,
                                        :trueanswer => "Ya",
                                        :falseanswer => "Tidak",
                                        :created_by => session[:user].login)
      eval_tf.save!
    end

    #D penilaian kemudahan
    subc_id = 7
    d_list = ["Penginapan",
              "Makanan",
              "Bilik Kuliah",
              "Nota-nota",
              "Kemudahan Komputer",
              "Kemudahan Sukan/Riadah"]
    d_list.size.times do |i|
      eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                          :evaluation_section_id => 4,
                                          :evaluation_subsection_id => subc_id,
                                          :questiontext => d_list[i],
                                          :created_by => session[:user].login,
                                          :evaluation_type_id => 5)
      eval_quest.save!
      eval_rnkg = EvaluationRanking.new(:evaluation_question_id => eval_quest.id,
                                        :max_ranking => skala,
                                        :created_by => session[:user].login)
      eval_rnkg.save!
    end

    redirect_to :action => 'show', :id => @evaluation.course_implementation.id

  end

  def topic_new
    @trainers = Trainer.find_by_sql("SELECT t.id,t.profile_id,p.name from trainers t, profiles p WHERE p.id=t.profile_id ORDER BY name");
    @evaluation = Evaluation.find(params[:id])
  end

  def topic_create
    @topic = Topic.new(params[:topic])
    @topic.save!

    @evaluation = Evaluation.find(params[:id])
    @cid = @evaluation.course_implementation_id

    t_list = ["Isi Kandungan", "Penyampaian", "Kaitan Isi Kandungan dengan Kursus"]
    t_list.size.times do |j|
      eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                          :evaluation_section_id => 2,
                                          :evaluation_subsection_id => 2,
                                          :questiontext => t_list[j],
                                          :created_by => session[:user].login,
                                          :evaluation_type_id => 4)
      eval_quest.save!
      eval_trn_rnkg = EvaluationTrainerRanking.new(:topic_id => @topic.id,
                                                   :trainer_id => @topic.trainer_id,
                                                   :evaluation_question_id => eval_quest.id,
                                                   :created_by => session[:user].login,
                                                   :max_ranking => params[:max_ranking])
      eval_trn_rnkg.save!
    end
    redirect_to :action => "show", :id => @cid
  end

  def topic_destroy
    @topic = Topic.find(params[:id])

    if @topic.evaluation_trainer_rankings.size > 0
      @eq = @topic.evaluation_trainer_rankings.first.evaluation_question
      if !@eq.evaluation.editable?
        render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
      end
      for etr in @topic.evaluation_trainer_rankings
        etr.evaluation_question.destroy
        etr.destroy
      end
    end
    @topic.destroy
    redirect_to :action => "show", :id => @topic.course_implementation_id
  end

  def create_penilaian #create penilaian by topics penceramah

    @course_implementation = CourseImplementation.find(params[:id])

    @evaluation = Evaluation.new
    @evaluation.course_implementation = @course_implementation
    @evaluation.name = "Penilaian Kursus(#{@course_implementation.code})"
    @evaluation.created_by = session[:user].login
    @evaluation.save

    #B topic - penceramah
    @topics = @course_implementation.topics
    #render :text=> @timetables.size and return
    t_list = ["Isi Kandungan", "Penyampaian", "Kaitan Isi Kandungan dengan Kursus"]
    if @timetables.size > 0
      @timetables.size.times do |i|
        tt = @timetables[i]
        if tt.trainers.size > 0
          t_list.size.times do |j|
            eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                                :evaluation_section_id => 2,
                                                :evaluation_subsection_id => 2,
                                                :questiontext => t_list[j],
                                                :created_by => session[:user].login,
                                                :evaluation_type_id => 4)
            eval_quest.save!
            eval_trn_rnkg = EvaluationTrainerRanking.new(:timetable_id => tt.id,
                                                         :trainer_id => tt.trainers.first.id,
                                                         :evaluation_question_id => eval_quest.id,
                                                         :created_by => session[:user].login,
                                                         :max_ranking => 5)
            eval_trn_rnkg.save!
          end
        end
      end
    end

    #C
    skala = 5
    a_list = ["Kesinambungan Topik-topik", "Penekanan kepada teori", "Penekanan kepada praktis"]
    b_list = ["Syarahan/Ceramah", "Kajian Kes", "Latihamal", "Perbincangan", "Lawatan"]
    c_list = ["Interaksi dengan peserta-peserta", "Kesediaan menerima maklumbalas", "Kesediaan bertindak atas maklumbalas"]
    all_list = [a_list, b_list, c_list]

    @c_subsections = EvaluationSection.find(3).evaluation_subsections
    subc_id = 3
    all_list.size.times do |h|
      all_list[h].size.times do |i|
        eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                            :evaluation_section_id => 3,
                                            :evaluation_subsection_id => subc_id,
                                            :questiontext => all_list[h][i],
                                            :created_by => session[:user].login,
                                            :evaluation_type_id => 5)
        eval_quest.save!
        eval_rnkg = EvaluationRanking.new(:evaluation_question_id => eval_quest.id,
                                          :max_ranking => skala,
                                          :created_by => session[:user].login)
        eval_rnkg.save!
      end
      subc_id = subc_id+1
    end

    #C true/false
    subc_id = 6
    d_list = ["Apakah anda telah mendapat faedah dari kursus ini?",
              "Adakah anda ingin memperakukan kursus ini kepada orang lain",
              "Adakah jangkamasa kursus bersesuaian"]
    d_list.size.times do |i|
      eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                          :evaluation_section_id => 3,
                                          :evaluation_subsection_id => subc_id,
                                          :questiontext => d_list[i],
                                          :created_by => session[:user].login,
                                          :evaluation_type_id => 6)
      eval_quest.save!
      eval_tf = EvaluationTruefalse.new(:evaluation_question_id => eval_quest.id,
                                        :trueanswer => "Ya",
                                        :falseanswer => "Tidak",
                                        :created_by => session[:user].login)
      eval_tf.save!
    end

    #D penilaian kemudahan
    subc_id = 7
    d_list = ["Penginapan",
              "Makanan",
              "Bilik Kuliah",
              "Nota-nota",
              "Kemudahan Komputer",
              "Kemudahan Sukan/Riadah"]
    d_list.size.times do |i|
      eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                          :evaluation_section_id => 4,
                                          :evaluation_subsection_id => subc_id,
                                          :questiontext => d_list[i],
                                          :created_by => session[:user].login,
                                          :evaluation_type_id => 5)
      eval_quest.save!
      eval_rnkg = EvaluationRanking.new(:evaluation_question_id => eval_quest.id,
                                        :max_ranking => skala,
                                        :created_by => session[:user].login)
      eval_rnkg.save!
    end

    redirect_to :action => 'show', :id => @evaluation.course_implementation.id

  end

  def user_hyouka
    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    if params[:ca_id]
      @student = CourseApplication.find(params[:ca_id])
      @course_implementation = @student.course_implementation
      @topics = Topic.find(:all, :conditions => "course_implementation_id=#{@course_implementation.id}")
    end
    if @course_implementation.evaluations.size == 0
      render :text => 'Soalan penilaian belum di setkan' and return
    end

    @evaluation = @course_implementation.evaluations.first
    @section_b_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=4")
    #@section_b_list = EvaluationQuestion.find_by_sql("SELECT eq.*,etr.timetable_id FROM evaluation_questions as eq INNER JOIN evaluation_trainer_rankings as etr ON etr.evaluation_question_id=eq.id WHERE order by timetable_id,id asc")
    @section_c_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=5")

    sql = "SELECT id FROM evaluation_answers ea WHERE course_application_id=#{params[:ca_id]}"
    @alreadys = EvaluationQuestion.find_by_sql(sql)
    #render :text=> @alreadys.size and return
    #@alreadys= []
    #render :text=> @alreadys.size and return
    if @alreadys.size > 0
      if @student.student_status_id==88
        #render :text=> "<center><b>Anda telah selesai menjawab soalan penilaian.<br>Terima kasih atas kerjasama yang anda berikan.</b><br><input type=button onclick='window.close()' value='Keluar'></center>" and return
        @can_update = 0
      else
        render :action => 'user_hyouka_edit'
        #render :text=> "kena edit" and return
      end
    end

  end

  def user_hyouka_edit
    #user_hyouka_answer
  end

  def user_hyouka_update
    @course_implementation = CourseImplementation.find(params[:id])
    @student = CourseApplication.find(params[:ca_id])
    if @course_implementation.evaluations.size == 0
      render :text => 'Soalan penilaian belum di setkan' and return
    end
    @evaluation = @course_implementation.evaluations.first
    @q_list = @course_implementation.evaluations.first.evaluation_questions
    #@q_list = EvaluationQuestion.find(:all, :conditions=>"evaluation_id=#{@evaluation.id} and evaluation_section_id=2")
    for q in @q_list
      #z = EvaluationAnswer.new( :profile_id=>session[:user].profile.id,
      #                                                  :course_implementation_id => @course_implementation.id,
      #                                                  :course_application_id => params[:ca_id],
      #                                                  :evaluation_question_id=>q.id,
      #                                                  :answer=>params["#{q.id}"],
      #                                                  :answer_comment=>params["comment_#{q.id}"],
      #                                                  :created_by=>session[:user].login)
      #z.save
      z = EvaluationAnswer.find_by_sql("SELECT * from evaluation_answers WHERE evaluation_question_id=#{q.id} AND course_application_id=#{params[:ca_id]}")
      if z!=nil
        z.first.update_attributes(:answer => params["#{q.id}"],
                                  :answer_comment => params["comment_#{q.id}"])
      end
    end

    c = EvaluationComment.find_by_sql("DELETE FROM evaluation_comments WHERE profile_id=#{session[:user].profile.id} AND course_implementation_id=#{@course_implementation.id}")

    if params[:comments]
      params[:comments].size.times do |i|
        if params[:comments][i] != ""
          c = EvaluationComment.new(:profile_id => session[:user].profile.id,
                                    :course_implementation_id => @course_implementation.id,
                                    :course_application_id => params[:ca_id],
                                    :comment => params[:comments][i],
                                    :created_by => session[:user].login)
          c.save
        end
      end
    end

    if !@student.all_answered?
      flash[:notice] = '<font style="color:red; font-weight:bold">Sila jawab kesemua soalan.</bold>'
      if params[:klm] == "1"
        redirect_to("/evaluations/user_hyouka?ca_id=#{params[:ca_id]}&klm=1") and return
      else
        redirect_to("/evaluations/user_hyouka?ca_id=#{params[:ca_id]}") and return
      end
    end

    render :text => "<center><b>Jawapan telah dikemaskini.<br><input type=button onclick='window.close()' value='Keluar'>"
  end

  def hyouka_hozon
    @course_implementation = CourseImplementation.find(params[:id])
    if @course_implementation.evaluations.size == 0
      render :text => 'Soalan penilaian belum di setkan' and return
    end
    @student = CourseApplication.find(params[:ca_id])
    @evaluation = @course_implementation.evaluations.first
    @q_list = @course_implementation.evaluations.first.evaluation_questions
    #@q_list = EvaluationQuestion.find(:all, :conditions=>"evaluation_id=#{@evaluation.id} and evaluation_section_id=2")
    for q in @q_list
      z = EvaluationAnswer.new(:profile_id => @student.profile.id,
                               :course_implementation_id => @course_implementation.id,
                               :course_application_id => params[:ca_id],
                               :evaluation_question_id => q.id,
                               :answer => params["#{q.id}"],
                               :answer_comment => params["comment_#{q.id}"],
                               :created_by => session[:user].login)
      z.kelompok = "1" if params[:klm] == "1"
      z.save
    end
    #render :text=> @q_list.size and return;

    if params[:comments]
      params[:comments].size.times do |i|
        if params[:comments][i] != ""
          c = EvaluationComment.new(:profile_id => session[:user].profile.id,
                                    :course_implementation_id => @course_implementation.id,
                                    :course_application_id => params[:ca_id],
                                    :comment => params[:comments][i],
                                    :created_by => session[:user].login)
          c.save
        end
      end
    end

    if !@student.all_answered?
      flash[:notice] = '<font style="color:red; font-weight:bold">Sila jawab kesemua soalan.</bold>' +
          "<script>alert('Sila jawab kesemua soalan')</script>"
      if params[:klm] == "1"
        redirect_to("/evaluations/user_hyouka?ca_id=#{@student.id}&klm=1") and return
      else
        redirect_to("/evaluations/user_hyouka?ca_id=#{@student.id}") and return
      end
    end
    render :text => "<center><b>Anda telah selesai menjawab soalan-soalan penilaian.<br>Terima kasih atas kerjasama yang anda berikan.</b><br><input type=button onclick='window.opener.location.reload();window.close()' value='Keluar'></center>" and return

  end

  def user_hyouka_answer_kelompok
    @by_kelompok
    user_hyouka_answer
  end

  def user_hyouka_answer
    @course_implementation = CourseImplementation.find(params[:id]) if params[:id]
    if params[:ca_id]
      @student = CourseApplication.find(params[:ca_id])
      @course_implementation = @student.course_implementation
      @topics = Topic.find(:all, :conditions => "course_implementation_id=#{@course_implementation.id}")
    end
    if @course_implementation.evaluations.size == 0
      render :text => 'Soalan penilaian belum di setkan' and return
    end
    sql = "SELECT eq.id FROM evaluation_questions as eq INNER JOIN evaluation_answers as ea ON ea.evaluation_question_id=eq.id WHERE profile_id = #{@student.profile.id}"
    @alreadys = EvaluationQuestion.find_by_sql(sql)
    if @alreadys.size < 1
      render :text => "<p><center><b>Peserta ini belum selesai menjawab soalan penilaian.<br></b><p><input type=button onclick='window.close()' value='Keluar'></center>" and return
    end

    @evaluation = @course_implementation.evaluations.first
    @section_b_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=4")
    #@section_b_list = EvaluationQuestion.find_by_sql("SELECT eq.*,etr.timetable_id FROM evaluation_questions as eq INNER JOIN evaluation_trainer_rankings as etr ON etr.evaluation_question_id=eq.id order by timetable_id,id asc")
    @section_c_list = EvaluationQuestion.find(:all, :conditions => "evaluation_id=#{@evaluation.id} and evaluation_type_id=5")

    render :layout => 'user_evaluation_answer'
  end

  def ev_quest_destroy
    @tt = Timetable.find(params[:id])
    @cid = @tt.evaluation_trainer_rankings.first.evaluation_question.evaluation.course_implementation.id
    @eq = @tt.evaluation_trainer_rankings.first.evaluation_question
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
    for etr in @tt.evaluation_trainer_rankings
      etr.evaluation_question.destroy
      etr.destroy
    end
    redirect_to :action => "show", :id => @cid

  end

  def trainer_ranking_new
    @tt = Timetable.find(params[:id])
    @cid = @tt.course_implementation_id
  end

  def trainer_ranking_create
    @tt = Timetable.find(params[:id])
    @evaluation = @tt.evaluation_trainer_rankings.first.evaluation_question.evaluation
    @cid = @tt.course_implementation_id
    eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                        :evaluation_section_id => 2,
                                        :evaluation_subsection_id => 2,
                                        :questiontext => params[:questiontext],
                                        :evaluation_type_id => 4)
    eval_quest.save!
    eval_trn_rnkg = EvaluationTrainerRanking.new(:timetable_id => @tt.id,
                                                 :trainer_id => @tt.trainers.first.id,
                                                 :evaluation_question_id => eval_quest.id,
                                                 :max_ranking => params[:max_ranking])
    eval_trn_rnkg.save!
    redirect_to :action => "show", :id => @cid
  end

  def ranking_new
    @evaluation = Evaluation.find(params[:id])
  end

  def ranking_create
    @evaluation = Evaluation.find(params[:id])
    @cid = @evaluation.course_implementation.id
    eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                        :evaluation_section_id => params[:section],
                                        :evaluation_subsection_id => params[:subsection],
                                        :questiontext => params[:questiontext],
                                        :evaluation_type_id => 5)
    eval_quest.save!
    eval_rnkg = EvaluationRanking.new(:evaluation_question_id => eval_quest.id,
                                      :max_ranking => params[:max_ranking])
    eval_rnkg.save!
    redirect_to :action => "show", :id => @cid
  end

  def truefalse_new
    @evaluation = Evaluation.find(params[:id])
  end

  def truefalse_create
    @evaluation = Evaluation.find(params[:id])
    @cid = @evaluation.course_implementation.id
    eval_quest = EvaluationQuestion.new(:evaluation_id => @evaluation.id,
                                        :evaluation_section_id => params[:section],
                                        :evaluation_subsection_id => params[:subsection],
                                        :questiontext => params[:questiontext],
                                        :evaluation_type_id => 6)
    eval_quest.save!
    eval_truefalse = EvaluationTruefalse.new(:evaluation_question_id => eval_quest.id,
                                             :trueanswer => "Ya",
                                             :falseanswer => "Tidak")
    eval_truefalse.save!
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_sub_destroy
    @eq = EvaluationQuestion.find(params[:id])
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
    @cid = @eq.evaluation.course_implementation_id
    @eq.evaluation_trainer_ranking.destroy
    @eq.destroy
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_sub_edit
    @eq = EvaluationQuestion.find(params[:id])
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
  end

  def ev_quest_sub_update
    @eq = EvaluationQuestion.find(params[:id])
    @cid = @eq.evaluation.course_implementation_id
    @eq.update_attributes(:questiontext => params[:questiontext])
    @eq.evaluation_trainer_ranking.update_attributes(:max_ranking => params[:max_ranking])
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_section_c_sub_edit
    @eq = EvaluationQuestion.find(params[:id])
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
  end

  def ev_quest_section_c_sub_update
    @eq = EvaluationQuestion.find(params[:id])
    @cid = @eq.evaluation.course_implementation_id
    @eq.update_attributes(:questiontext => params[:questiontext])
    @eq.evaluation_ranking.update_attributes(:max_ranking => params[:max_ranking])
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_section_c_sub_destroy
    @eq = EvaluationQuestion.find(params[:id])
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
    @cid = @eq.evaluation.course_implementation_id
    @eq.evaluation_ranking.destroy
    @eq.destroy
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_section_c_truefalse_sub_edit
    @eq = EvaluationQuestion.find(params[:id])
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
  end

  def ev_quest_section_c_truefalse_sub_destroy
    @eq = EvaluationQuestion.find(params[:id])
    @cid = @eq.evaluation.course_implementation_id
    if !@eq.evaluation.editable?
      render :text => "<div style=\"color:red;text-align:center\">Template soalan bagi penilaian untuk kursus ini tidak boleh diedit/padam kerana peserta sudah menjawab soalan-soalannya.</div><p><center><a href=\"javascript: history.back()\">Kembali</a></center>" and return
    end
    @eq.destroy
    redirect_to :action => "show", :id => @cid
  end

  def ev_quest_section_c_truefalse_sub_update
    @eq = EvaluationQuestion.find(params[:id])
    @cid = @eq.evaluation.course_implementation_id
    @eq.update_attributes(:questiontext => params[:questiontext])
    redirect_to :action => "show", :id => @cid
  end

  def create
    @evaluation = Evaluation.new(params[:evaluation])
    @evaluation.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @evaluation.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]

    if @evaluation.save
      flash[:notice] = 'Penilaian Telah Berjaya Disimpan'
      redirect_to :action => 'list', :id => @evaluation.course_implementation_id
    else
      redirect_to :action => 'new', :id => @evaluation.course_implementation_id
    end
  end

  def edit
    @evaluation = Evaluation.find(params[:id])
    if @evaluation.timeopen != nil
      today = @evaluation.timeopen
    else
      today = Time.new
    end
    @hour, @minute, @day, @month, @year = today.hour, today.min, today.day, today.month, today.year
    if @evaluation.timeclose != nil
      tomorrow = @evaluation.timeclose
    else
      tomorrow = today + (60 * 60)
    end
    @hour_next, @minute_next, @day_next, @month_next, @year_next = tomorrow.hour, tomorrow.min, tomorrow.day, tomorrow.month, tomorrow.year

  end

  def update
    @evaluation = Evaluation.find(params[:id])
    @evaluation.timeopen = params[:month_check_in]+"/"+params[:day_check_in]+"/"+params[:year_check_in] + " " +params[:hour_check_in]+":"+params[:minute_check_in]
    @evaluation.timeclose = params[:month_check_out]+"/"+params[:day_check_out]+"/"+params[:year_check_out] + " " +params[:hour_check_out]+":"+params[:minute_check_out]

    if @evaluation.update_attributes(params[:evaluation])
      flash[:notice] = 'Penilaian Telah Dikemaskinikan'
      redirect_to :action => 'list', :id => @evaluation.course_implementation_id
    else
      render :action => 'edit', :id => @evaluation.id
    end
  end

  def destroy
    Evaluation.find(params[:id]).destroy
    redirect_to :action => 'list', :id => params[:id]
  end

end
