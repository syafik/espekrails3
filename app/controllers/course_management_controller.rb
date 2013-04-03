# -*- encoding : utf-8 -*-
class CourseManagementController < ApplicationController
  #	require "pdf/writer"
  #	require "pdf/simpletable"
  layout "standard-layout"

  def initialize
    @states = State.find(:all, :order => "description")
    @genders = Gender.all
    @races = Race.find(:all, :order => "id")
    @profile_statuses = ProfileStatus.all
    @religions = Religion.find(:all, :order => "id")
    @countries = Country.all
    @marital_statuses = MaritalStatus.all
    @places = Place.find(:all, :conditions => "place_type_id = '2'")
    @relationships = Relationship.all
    @cert_levels = CertLevel.all
    @majors = Major.all
    @job_profiles = JobProfile.all
    @titles = Title.find(:all, :order => "description")
    @course_departments = CourseDepartment.all
    #@courses = Course.all
    #@course_implementations = CourseImplementation.all
    super
  end

  def index
    new
    render :action => 'new'
  end

  def new

  end

  def search_by_name
    @searches = CourseApplication.find_by_sql("select * from vw_detailed_applicants  WHERE student_status_id=4 AND personal_name ILIKE '%#{params[:name]}%'")
    #render :text=> @searches.size
  end

  def search_by_nric
    @searches = CourseApplication.find_by_sql("select * from vw_detailed_applicants  WHERE (student_status_id=1 OR student_status_id=2) AND nric ILIKE '%#{params[:nric]}%'")
    render :action => 'search_by_name'
  end

  def evaluated_courses
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")
    cur_year = Time.now.year
    if  !params[:year_start]
      params[:year_start] = cur_year
      where_date = "AND #{cur_year}=extract(year from date_plan_start)"
    else
      where_date = "AND #{params[:year_start]}=extract(year from date_plan_start)"
    end

    sql = "SELECT distinct(ci.id) as q,ci.* FROM
		 course_implementations ci,
			 course_applications ca,
			 evaluation_answers ea
	       WHERE ea.course_application_id=ca.id AND ci.id=ca.course_implementation_id #{where_date}"

    staff_id = nof { session[:user].profile.staff.id }
    if staff_id != nil
      #@course_implementations = CourseImplementation.find(:all, :conditions=> "extract(year from date_plan_start) = #{params[:year_start]} AND (coordinator1 = #{staff_id} OR coordinator2 = #{staff_id})", :order=>"date_plan_start DESC")
      @course_implementations = CourseImplementation.find_by_sql(sql)
    else
      @course_implementations = []
    end
  end

  def sijil_select_course
    select_course
  end

  def select_course
    @planning_years = CourseImplementation.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations")
    cur_year = Time.now.year
    Rails.logger.info cur_year
    params[:year_start] = cur_year if !params[:year_start]

    staff_id = nof { session[:user].profile.staff.id }
    if staff_id != nil
      @course_implementations = CourseImplementation.find(:all,
                                                          :conditions => "extract(year from date_plan_start) = #{params[:year_start]} AND (coordinator1 = #{staff_id} OR coordinator2 = #{staff_id} OR ketua_program = #{staff_id} OR pen_ketua_program =  #{staff_id})",
                                                          :order => "date_plan_start DESC")
    else
      @course_implementations = []
    end
    render :layout => "standard-layout"
  end

  def register
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND (student_status_id=4)")
      @students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=4) order by #{orderby} #{@arrow}")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    render :layout => "standard-layout"
  end

  def list_signature
    ichiran
  end

  def ichiran
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
      @students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
      #@students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by name asc")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    render :layout => "standard-layout"
  end

  def yuran
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      #@students = CourseApplication.find(:all, :conditions=>"course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
      #@students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9)order by name ASC")
      @students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    render :layout => "standard-layout"
  end

  def tempah_sijil
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5 AND layak_sijil='1'")
    @tempahan_sijil = @course_implementation.tempahan_sijil
    @tempahan_sijil = TempahanSijil.new if @tempahan_sijil == nil
    @course_departments = CourseDepartment.all
    @coordinators= Staff.find_by_sql("SELECT staffs.* from staffs INNER join profiles ON staffs.profile_id=profiles.id order by name asc")

    #render :text => "jj" + @cert_policy and return;
  end

  def edit_tempah_sijil
    tempah_sijil
  end

  def hantar_tempahan
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    if @course_implementation.tempahan_sijil == nil
      arr = params[:tempahan_sijil]["tarikh"].split('/')
      params[:tempahan_sijil]["tarikh"] = arr[1] + "/" + arr[0] + "/" + arr[2]
      @ts = TempahanSijil.new(params[:tempahan_sijil])
      @ts.course_implementation_id = @course_implementation.id
      begin
        @ts.save
      rescue
        flash[:notice] = "Error saving tempahan sijil."
        render :action => "tempah_sijil", :id => @course_implementation.id
      end
    else
      arr = params[:tempahan_sijil]["tarikh"].split('/')
      params[:tempahan_sijil]["tarikh"] = arr[1] + "/" + arr[0] + "/" + arr[2]
      @course_implementation.tempahan_sijil.update_attributes(params[:tempahan_sijil])
    end
    EspekMailer.deliver_hantar_tempahan(@course_implementation.id, params[:tempahan_sijil]["penerima"])
    flash[:notice] = "Tempahan pengeluaran sijil telah berjaya dihantar."
    redirect_to :action => "tempah_sijil", :id => @course_implementation.id
  end

  def sah_tempahan_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")

    params[:tempahan_sijil]["disahkan_oleh"] = session[:user].profile.staff.id
    params[:tempahan_sijil]["disahkan_oleh_user"] = session[:user].id
    params[:tempahan_sijil]["status"] = '1'

    if @course_implementation.tempahan_sijil != nil
      @course_implementation.tempahan_sijil.update_attributes(params[:tempahan_sijil])
      flash[:notice] = "Tempahan sijil telah disahkan."
    else
      flash[:notice] = "<script>alert('Tempahan sijil masih belum dilakukan oleh penyelaras.')</script>"
    end
    redirect_to :action => "edit_tempah_sijil", :id => @course_implementation.id
  end

  def cetak_tempahan_iso
    tempah_sijil
    pdf = PDF::Writer.new(:paper => "A4", :orientation => :potrait)
    pdf.select_font("Helvetica")
    pdf.margins_pt(36, 35, 36, 35) # 36 54 72 90
                                   #pdf.margins_mm(5)

    @font_size_normal = 9

    @font_size_large = 11

    pdf.text "  <b>BORANG PERMOHONAN SIJIL</b>", :font_size => @font_size_large, :justification => :center

    #NAMA KURSUS
    #table1 = PDF::SimpleTable.new
    #table1.column_order.push(*%w(1st))
    #table1.show_lines	= :none
    #table1.shade_rows   = :none
    #table1.position	    = 350
    #table1.width	    = 400
    #table1.show_headings = false
    #table1.orientation	= :center
    #table1.font_size = 9
    #data_all_1=[]
    #data = [
    #   {"1st"=> "#{@course_implementation.course.name.upcase}" }
    #]
    #data_all_1 = data_all_1 + data
    #table1.data.replace data_all_1
    #table1.render_on(pdf)
    @rujukan_font_size = 9
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "TAJUK KURSUS", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    fsize = @rujukan_font_size
    if @course_implementation.course.name.length > 70
      fsize = 7
    end
    pdf.add_text(150, pdf.y, "#{@course_implementation.course.name}", fsize)
    #pdf.y = pdf.y - 10
    #pdf.add_text(150, pdf.y, "ABVC AKDKJ AKLJD ADKJFD)", @rujukan_font_size)

    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "ANJURAN", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(150, pdf.y, params[:tempahan_sijil][:anjuran], @rujukan_font_size)

    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "KOD KURSUS", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(150, pdf.y, @course_implementation.code, @rujukan_font_size)

    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "BAHAGIAN", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(150, pdf.y, @course_implementation.course.course_department.description.upcase, @rujukan_font_size)

    #pdf.add_text(60, pdf.y, "KOD KURSUS", @rujukan_font_size)
    #pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    #pdf.add_text(160, pdf.y, "#{@course_implementation.code}", @rujukan_font_size)
    #pdf.text(" \n")

    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "TARIKH KURSUS", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(150, pdf.y, "#{@course_implementation.date_start.to_formatted_s(:my_format_4)} HINGGA #{@course_implementation.date_end.to_formatted_s(:my_format_4)}", @rujukan_font_size)


    pdf.text(" \n")
    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 4th 5th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "BIL"
    table.columns["1st"].justification = :center
    table.columns["1st"].width = 25

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "NAMA"
    table.columns["2nd"].heading.justification = :center
    table.columns["2nd"].width = 150

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "NO. KAD PENGENALAN"
    table.columns["3rd"].heading.justification = :center
    table.columns["3rd"].justification = :center
    table.columns["3rd"].width = 60

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "JABATAN"
    table.columns["4th"].heading.justification = :center
    table.columns["4th"].justification = :left
    table.columns["4th"].width = 150

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "NO. SIJIL"
    table.columns["5th"].heading.justification = :center
    table.columns["5th"].width = 80

    table.show_lines = :inner
    table.shade_rows = :none
    table.width = 450
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 7
    table.heading_font_size = 7

    data_all=[]
    jumlah = 0
    @students.each_with_index do |stu, idx|
      if (stu.markah_ujian_akhir != nil) and (stu.markah_penilaian_peserta != nil)
        total = nof { stu.markah_ujian_akhir } + nof { stu.markah_penilaian_peserta }
      else
        total = 0
      end
      data = [
          {"1st" => idx+1, "2nd" => stu.profile.name, "3rd" => stu.profile.ic_number, "4th" => nof { stu.profile.opis }, "5th" => " \n "}
      ]
      #data["5th"].justification = :center
      data_all = data_all + data
    end

    table.data.replace data_all
    table.render_on(pdf)
    @font_size_normal = 9

    pdf.text(" \n\n")
    pdf.text("           PENCERAMAH", :font_size => @rujukan_font_size)
    pdf.text(" \n")
    gen_jadual(pdf)

    pdf.new_page
    pdf.y = pdf.absolute_top_margin - 40
    pdf.text(" \n\n")
    pdf.text("           FASILITATOR", :font_size => @rujukan_font_size)
    pdf.text(" \n")
    gen_jadual(pdf)
    gen_serahan(pdf)

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/yuran/" + "tempah_sijil.pdf") #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/yuran/" + "tempah_sijil.pdf") #kalu kat bsd
    end
    #redirect_to("/course_management/yuran/#{@course_implementation.id}?apply_status=yuran")
    redirect_to("/yuran/" + "tempah_sijil.pdf")

  end

  #private
  def gen_serahan(pdf)
    jarak = 250
    @dotdot = "......................................"
    @rujukan_font_size = 10
    pdf.text(" \n\n\n\n\n\n\n")
    pdf.add_text(60, pdf.y, "MAKLUMAT PEMOHON", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "Nama:", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.add_text(60+jarak, pdf.y, "Jawatan:", @rujukan_font_size)
    pdf.add_text(130+jarak, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140+jarak, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "Bahagian", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.add_text(60+jarak, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(130+jarak, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140+jarak, pdf.y, @dotdot, @rujukan_font_size)

    pdf.text(" \n\n\n\n\n\n\n")
    pdf.add_text(60, pdf.y, "MAKLUMAT SERAHAN SIJIL", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text("        Saya dengan ini mengesahkan bahawa sijil-sijil tersebut telah diterima dan disemak serta disahkan \n        tiada pindaan oleh saya. Sekian.", :font_size => @rujukan_font_size, :justification => :left)
    #pdf.add_text(60, pdf.y, "Saya dengan ini mengesahkan bahawa sijil-sijil tersebut telah diterima dan disemak serta disahkan \ntiada pindaan oleh saya. Sekian.", @rujukan_font_size)
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(134, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.add_text(60+jarak, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(134+jarak, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140+jarak, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "Nama Penerima", @rujukan_font_size)
    pdf.add_text(134, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.add_text(60+jarak, pdf.y, "Nama Pereka", @rujukan_font_size)
    pdf.add_text(134+jarak, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140+jarak, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n\n")
    pdf.add_text(60, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(134, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.add_text(60+jarak, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(134+jarak, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140+jarak, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
  end

  #private
  def gen_jadual (pdf)
    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 4th 5th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "BIL"
    table.columns["1st"].justification = :center
    table.columns["1st"].width = 25

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "NAMA"
    table.columns["2nd"].heading.justification = :center
    table.columns["2nd"].width = 150

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "NO. KAD PENGENALAN"
    table.columns["3rd"].heading.justification = :center
    table.columns["3rd"].justification = :center
    table.columns["3rd"].width = 60

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "JABATAN"
    table.columns["4th"].heading.justification = :center
    table.columns["4th"].justification = :left
    table.columns["4th"].width = 150

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "NO. SIJIL"
    table.columns["5th"].heading.justification = :center
    table.columns["5th"].width = 80

    table.show_lines = :inner
    table.shade_rows = :none
    table.width = 450
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 7
    table.heading_font_size = 7

    data_all=[]
    jumlah = 0
    5.times do |i|
      p = nof { @course_implementation.trainers[i].profile }
      data = [
          {"1st" => i+1, "2nd" => "#{nof { p.name }}\n", "3rd" => "#{nof { p.ic_number }}\n", "4th" => "#{nof { p.opis.upcase }}\n", "5th" => " \n "}
      ]
      data_all = data_all + data
    end

    table.data.replace data_all
    table.render_on(pdf)
    @font_size_normal = 9
  end

  def cetak_tempahan
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    if @course_implementation.tempahan_sijil == nil
      arr = params[:tempahan_sijil]["tarikh"].split('/')
      params[:tempahan_sijil]["tarikh"] = arr[1] + "/" + arr[0] + "/" + arr[2]
      @ts = TempahanSijil.new(params[:tempahan_sijil])
      @ts.course_implementation_id = @course_implementation.id
      begin
        @ts.save
      rescue
        flash[:notice] = "Error saving tempahan sijil."
        render :action => "tempah_sijil", :id => @course_implementation.id
      end
    else
      arr = params[:tempahan_sijil]["tarikh"].split('/')
      params[:tempahan_sijil]["tarikh"] = arr[1] + "/" + arr[0] + "/" + arr[2]
      @course_implementation.tempahan_sijil.update_attributes(params[:tempahan_sijil])
    end
  end

  def override_kelayakan
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    for student in @students
      student.update_attributes(:layak_sijil => params[:layak]["#{student.id}"], :cert_remark => params[:cert_remarks]["#{student.id}"])
    end
    flash[:notice] = "Kelayakan sijil berjaya dikemaskini secara manual."
    redirect_to :action => "certificate", :id => @course_implementation.id

  end

  def set_paparan_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @default_font_size = '18'
  end

  def override_no_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5 ")
    for student in @students
      student.update_attributes(:no_sijil => params[:cert_nos]["#{student.id}"].to_i)
    end
    flash[:notice] = "Nombor sijil berjaya dikemaskini secara manual."
    redirect_to :action => "cetak_sijil", :id => @course_implementation.id

  end

  def jana_no_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,ca.layak_sijil,ca.payment_date,ca.fee_amount, p.name from course_applications as ca join profiles as p on ca.profile_id=p.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5)  order by #{orderby} #{@arrow}")

      #latest_no = getNoSijilTerkini(@course_implementation.course.course_department_id).to_i
      dept_id = @course_implementation.course.course_department_id
      sql = "SELECT no_sijil FROM vw_detailed_peserta WHERE course_department_id=#{dept_id} AND no_sijil!='' ORDER BY no_sijil DESC LIMIT 1"
      a = CourseApplication.find_by_sql(sql)
      if a.size > 0
        latest_no = a[0].no_sijil.to_i
      else
        latest_no = 0
      end
      for s in @students
        student = CourseApplication.find(s.id)
        next if student.layak_sijil != '1'
        latest_no = latest_no + 1
        student.update_attributes(:no_sijil => latest_no)
      end
      flash[:notice] = "Nombor sijil berjaya dijana oleh sistem."
      redirect_to :action => "cetak_sijil", :id => @course_implementation.id

    else
      @students = []
    end
  end

  def jana_kelayakan
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,ca.layak_sijil,ca.payment_date,ca.fee_amount, p.name from course_applications as ca join profiles as p on ca.profile_id=p.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5)  order by #{orderby} #{@arrow}")

      if @course_implementation.cert_policy != nil
        yuran = @course_implementation.cert_policy.wajib_yuran
      else
        yuran = '0'
      end

      if @course_implementation.cert_policy != nil
        min_att = @course_implementation.cert_policy.kehadiran_minima
      else
        min_att = 50
      end

      #render :text=> min_att and return;

      for s in @students
        student = CourseApplication.find(s.id)
        flag = 1;
        att = student.getAttPercent(student.id)

        #kehadiran
        if student.getAttPercent(student.id) < min_att
          student.update_attributes(:layak_sijil => "0")
          next
        end

        #yuran
        if yuran == "1"
          if student.fee_paid? == "T"
            student.update_attributes(:layak_sijil => "0")
            next
          end
        end

        student.update_attributes(:layak_sijil => "1")

      end
      flash[:notice] = "Kelayakan sijil berjaya dijana oleh sistem."
      redirect_to :action => "certificate", :id => @course_implementation.id

    else
      @students = []
    end


  end

  def certificate
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,ca.layak_sijil,ca.payment_date,ca.fee_amount,ca.cert_remark,ca.no_sijil, p.name from course_applications as ca join profiles as p on ca.profile_id=p.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5) order by #{orderby} #{@arrow}")
    else
      @students = []
    end
    render :layout => "standard-layout"
  end

  def cetak_p_evaluation
    evaluation
  end

  def cetak_p_evaluation_iso
    evaluation
    pdf = PDF::Writer.new(:paper => "A4", :orientation => :potrait)
    pdf.select_font("Helvetica")
    pdf.margins_pt(36, 35, 36, 35) # 36 54 72 90
                                   #pdf.margins_mm(5)

    @font_size_normal = 9

    @font_size_large = 11
                                   #pdf.image @signature_file, :resize => 0.5
    if RUBY_PLATFORM == "i386-mswin32"
      head_file = "public/images/header_penilaian_iso.png"
    else
      head_file = "/aplikasi/www/instun/public/images/header_penilaian_iso.png"
    end
    pdf.image "#{head_file}", :justification => :center
                                   #pdf.text "_________________", :font_size => @font_size_large, :justification => :center
    pdf.text(" \n\n")

    #NAMA KURSUS
    table1 = PDF::SimpleTable.new
    table1.column_order.push(*%w(1st))
    table1.show_lines = :none
    table1.shade_rows = :none
    table1.position = 360
    table1.width = 400
    table1.show_headings = false
    table1.orientation = :center
    table1.font_size = 9
    data_all_1=[]
    data = [
        {"1st" => "#{@course_implementation.course.name.upcase}"}
    ]
    data_all_1 = data_all_1 + data
    table1.data.replace data_all_1
    table1.render_on(pdf)
    @rujukan_font_size = 9
    pdf.add_text(60, pdf.y, "NAMA KURSUS", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    #pdf.add_text(160, pdf.y, "#{@course_implementation.course.name.upcase} (#{@course_implementation.code})", @rujukan_font_size)
    #pdf.text(" \n")
    pdf.y = pdf.y + -5 #to make some space between tables

    #KOD KURSUS
    table1 = PDF::SimpleTable.new
    table1.column_order.push(*%w(1st))
    table1.show_lines = :all
    table1.shade_rows = :none
    table1.position = 190
    table1.width = 50
    table1.show_headings = false
    table1.orientation = :center
    table1.font_size = 9
    data_all_1=[]
    data = [
        {"1st" => "#{@course_implementation.code}"}
    ]
    data_all_1 = data_all_1 + data
    table1.data.replace data_all_1
    table1.render_on(pdf)
    pdf.add_text(60, pdf.y, "KOD KURSUS", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    #pdf.add_text(160, pdf.y, "#{@course_implementation.code}", @rujukan_font_size)
    #pdf.text(" \n")
    pdf.y = pdf.y + -5 #to make some space between tables

    #TARIKH START
    table1 = PDF::SimpleTable.new
    table1.column_order.push(*%w(1st 2nd 3rd))
    table1.show_lines = :all
    table1.shade_rows = :none
    table1.position = 200
    table1.width = 70
    table1.show_headings = false
    table1.orientation = :center
    table1.font_size = 9
    data_all_1=[]
    data = [
        {"1st" => @course_implementation.date_start.to_formatted_s(:my_format_day),
         "2nd" => @course_implementation.date_start.to_formatted_s(:my_format_month),
         "3rd" => @course_implementation.date_start.to_formatted_s(:my_format_y)}
    ]
    data_all_1 = data_all_1 + data
    table1.data.replace data_all_1
    table1.render_on(pdf)
    pdf.add_text(60, pdf.y, "TARIKH", @rujukan_font_size)
    pdf.add_text(240, pdf.y, "HINGGA", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)

    #TARIKH END
    pdf.y = pdf.y + 15
    table1 = PDF::SimpleTable.new
    table1.column_order.push(*%w(1st 2nd 3rd))
    table1.show_lines = :all
    table1.shade_rows = :none
    table1.position = 330
    table1.width = 70
    table1.show_headings = false
    table1.orientation = :center
    table1.font_size = 9
    data_all_1=[]
    data = [
        {"1st" => @course_implementation.date_end.to_formatted_s(:my_format_day),
         "2nd" => @course_implementation.date_end.to_formatted_s(:my_format_month),
         "3rd" => @course_implementation.date_end.to_formatted_s(:my_format_y)}
    ]
    data_all_1 = data_all_1 + data
    table1.data.replace data_all_1
    table1.render_on(pdf)

    pdf.text(" \n")
    pdf.add_text(160, pdf.y, "(HARI)(BULAN)(TAHUN)                                     (HARI)(BULAN)(TAHUN)", 6)

    pdf.text(" \n")
    pdf.text "               PENILAIAN INI ADALAH SULIT DAN ANDA DIKEHENDAKI MENILAI SECARA JUJUR DAN IKHLAS.", :font_size => @font_size_normal, :justification => :left
    pdf.text(" \n")
    pdf.text "               <b>A. SKOR MARKAH</b>", :font_size => @font_size_normal, :justification => :left

    ################################
    #pdf.add_text(160, pdf.y, "#{@course_implementation.date_start} HINGGA #{@course_implementation.date_end}", @rujukan_font_size)
    pdf.text(" \n")

    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 4th 5th 6th 7th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "BIL"
    table.columns["1st"].justification = :center
    table.columns["1st"].width = 25

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "NAMA"
    table.columns["2nd"].heading.justification = :center
    #table.columns["2nd"].width = 150

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "NO. KAD PENGENALAN"
    table.columns["3rd"].heading.justification = :center
    table.columns["3rd"].justification = :center
    table.columns["3rd"].width = 80

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "JAWATAN   /GRED"
    table.columns["4th"].heading.justification = :left
    table.columns["4th"].justification = :center
    table.columns["4th"].width = 60

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "UJIAN AKHIR KURSUS 70%"
    table.columns["5th"].heading.justification = :center
    table.columns["5th"].width = 80

    table.columns["6th"] = PDF::SimpleTable::Column.new("6th")
    table.columns["6th"].heading = "PENILAIAN OLEH PENYELARAS"
    table.columns["6th"].heading.justification = :center
    table.columns["6th"].width = 80

    table.columns["7th"] = PDF::SimpleTable::Column.new("7th")
    table.columns["7th"].heading = "JUMLAH"
    table.columns["7th"].heading.justification = :center
    table.columns["7th"].justification = :center
    table.columns["7th"].width = 50

    table.show_lines = :inner
    table.shade_rows = :none
    table.width = 550
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 9
    table.heading_font_size = 9

    data_all=[]
    jumlah = 0
    @students.each_with_index do |stu, idx|
      if (stu.markah_ujian_akhir != nil) and (stu.markah_penilaian_peserta != nil)
        total = nof { stu.markah_ujian_akhir } + nof { stu.markah_penilaian_peserta }
      else
        total = 0
      end
      data = [
          {"1st" => idx+1, "2nd" => stu.profile.name, "3rd" => stu.profile.ic_number, "4th" => nof { stu.profile.employments.first.job_profile.job_grade },
           "5th" => stu.markah_ujian_akhir, "6th" => stu.markah_penilaian_peserta, "7th" => total}
      ]
      #data["5th"].justification = :center
      data_all = data_all + data
    end

    table.data.replace data_all
    table.columns["6th"].justification = :center
    table.render_on(pdf)
    @font_size_normal = 9

    pdf.text(" \n")
    pdf.text "  <b>NOTA</b>", :font_size => @font_size_normal, :justification => :left
    pdf.text(" \n")
    pdf.text "  1. PENILAIAN OLEH PENYELARAS MELIPUTI ASPEK DISPLIN, PENGLIBATAN DALAM AKTIVITI LUAR, KEHADIRAN DAN", :font_size => @font_size_normal
    pdf.text "      KERJASAMA YANG DIBERIKAN SEMASA BERKURSUS.", :font_size => @font_size_normal
    pdf.text(" \n")
    pdf.text "  2. PANDUAN KIRAAN WAJARAN 70%", :font_size => @font_size_normal
    pdf.text "      HASIL MARKAH KESELURUHAN YANG TELAH DIKIRA PERATUSANNYA PERLU DIDARABKAN DENGAN 0.7.", :font_size => @font_size_normal
    pdf.text(" \n")
    pdf.text "      CARA MENGIRA : TERDAPAT 40 SOALAN, JIKA CALON BETUL 35 SOALAN, MAKA    35  X  100 %  X  0.7 = 61.25", :font_size => @font_size_normal


    #BEST STUDENT
    @p_ev = ParticipantEvaluation.find_by_course_implementation_id(@course_implementation.id)
    #@p_ev.best_student = params[:best_student]
    #@p_ev.ulasan_keseluruhan = params[:ulasan_keseluruhan]

    pdf.new_page
    pdf.y = pdf.absolute_top_margin - 40
    pdf.text "  B. CADANGAN PESERTA TERBAIK (JIKA ADA) UNTUK DIBERI SIJIL PENGHARGAAN PESERTA TERBAIK", :font_size => @font_size_normal, :justification => :left
    pdf.text("\n")

    @p_ev = ParticipantEvaluation.new if @p_ev == nil
    if @p_ev.best_student != ''
      pdf.text(" #{@p_ev.best_student}")
    else
      pdf.text("___________________________________________")
      pdf.text("___________________________________________")
    end

    pdf.text("\n")
    pdf.text("\n")
    pdf.text("\n")
    pdf.text("\n")
    pdf.text "  C. ULASAN KESELURUHAN PRESTASI PESERTA OLEH PENYELARAS KURSUS / URUS SETIA", :font_size => @font_size_normal, :justification => :left
    pdf.text("\n")
    if @p_ev.ulasan_keseluruhan != ''
      pdf.text(" #{@p_ev.ulasan_keseluruhan}")
    else
      pdf.text("___________________________________________")
      pdf.text("___________________________________________")
      pdf.text("___________________________________________")
    end

    pdf.text("\n")
    pdf.text("\n")
    pdf.text("\n")
    pdf.text("\n")
    pdf.text "TANDATANGAN,", :font_size => @font_size_normal, :justification => :left
    pdf.text("\n")
    pdf.text("\n")
    pdf.text("\n")
    pdf.text("______________________")
    pdf.text "PENYELARAS PROGRAM", :font_size => @font_size_normal, :justification => :left

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/yuran/" + "penilaian_peserta.pdf") #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/yuran/" + "penilaian_peserta.pdf") #kalu kat bsd
    end
    #redirect_to("/course_management/yuran/#{@course_implementation.id}?apply_status=yuran")
    redirect_to("/yuran/" + "penilaian_peserta.pdf")
  end

  def kehadiran_peserta

  end


  def p_evaluation
    evaluation
  end

  def evaluation_done
    evaluation
  end

  def evaluation_kelompok
    evaluation

  end

  def evaluation
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:course_management_id]) if (params[:course_management_id] && params[:course_management_id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      @students = CourseApplication.find_by_sql("select ca.*,p.name from course_applications as ca join profiles as p on ca.profile_id=p.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
    render :layout => "standard-layout"
  end

  def kehadiran_peserta

  end

  def quiz

    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]
      @quizzes = Quiz.find_by_sql("select * from quizzes where course_implementation_id= #{@course_implementation.id}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9)")
      #@students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND student_status_id=5 order by name ASC")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
  end


  def cetak_sijil
    certificate
  end

  def surat_pengesahan
    certificate
  end

  def surat_takhadir
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,ca.layak_sijil,ca.payment_date,ca.fee_amount,ca.cert_remark,ca.no_sijil, p.name from course_applications as ca join profiles as p on ca.profile_id=p.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=6 or student_status_id=4) order by #{orderby} #{@arrow}")
    else
      @students = []
    end

  end

  def set_kelayakan_sijil
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    end

    for student in @students
      #render :text=> params['cert_remarks']['46']  , :layout=>false and return
      student.certificate.update_attributes(:is_qualified => params["cert_qualifies"]["#{student.id}"], :remark => params["cert_remarks"]["#{student.id}"])
    end
    redirect_to("/course_management/certificate/#{@course_implementation.id}?apply_status=certificate")
  end


  def enroll_selected
    for id in params[:course_application_ids]
      @student = CourseApplication.find(id)
      if @student.update_attributes(:student_status_id => "5")
        @certificate = Certificate.new(:course_application_id => "#{@student.id}")
        @certificate.save
      end
    end
    redirect_to("/course_management/register?course_implementation_id=#{@student.course_implementation.id}&apply_status=register")
  end

  def make_payment
    params[:ids].each_with_index do |id, idx|
      next if params[:dates][idx] == nil
      arr=params[:dates][idx].split('/')
      payment_date = arr[1] + "/" + arr[0] + "/" + arr[2]

      CourseApplication.find(id).update_attributes(:fee_amount => params[:amounts][idx], :receipt_no => params[:receipts][idx], :payment_date => payment_date, :is_paid => "1") if (params[:amounts][idx] !='-' && params[:receipts][idx] !='')
      @student = CourseApplication.find(id)
    end
    flash[:notice] = "Yuran peserta kursus telah dikemaskini."
    redirect_to("/course_management/yuran/#{@student.course_implementation.id}?apply_status=yuran")
  end

  def isi_markah
    params[:ids].each_with_index do |id, idx|
      #next if params[:dates][idx] == nil
      CourseApplication.find(id).update_attributes(:markah_penilaian_peserta => params[:markah_penilaian_peserta][idx],
                                                   :markah_ujian_akhir => params[:markah_ujian_akhir][idx],
                                                   :ulasan_urusetia => params[:ulasan_urusetia][idx]
      )
    end
    @student = CourseApplication.find(params[:ids][0])

    @course_implementation = @student.course_implementation

    @p_ev = ParticipantEvaluation.find_by_course_implementation_id(@course_implementation.id)
    @p_ev = ParticipantEvaluation.new if @p_ev == nil
    @p_ev.course_implementation_id = @course_implementation.id
    @p_ev.best_student = params[:best_student]
    @p_ev.ulasan_keseluruhan = params[:ulasan_keseluruhan]
    @p_ev.save

    flash[:notice] = "Markah peserta kursus telah dikemaskini."
    redirect_to("/course_management/p_evaluation/#{@student.course_implementation.id}?apply_status=yuran")
  end

  def enrolled
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      #@students = CourseApplication.find_by_sql("select * from vw_detailed_confirmed WHERE course_name='#{course.name}' order by #{params[:orderby]} #{params[:arrow]}")
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    else
      @students = []
    end
    @courses = Course.find(:all, :order => "name")
  end

  def new_polisi_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @cert_policy = @course_implementation.cert_policy
    @cert_policy = CertPolicy.new if @cert_policy == nil

    #render :text => "jj" + @cert_policy and return;
  end

  def update_polisi_sijil
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    if @course_implementation.cert_policy == nil
      @cp = CertPolicy.new(params[:cert_policy])
      @cp.course_implementation_id = @course_implementation.id
      begin
        @cp.save
        flash[:notice] = "Polisi berjaya dikemaskini."
        redirect_to :action => "new_polisi_sijil", :id => @course_implementation.id
      rescue
        flash[:notice] = "Error saving polisi."
        render :action => "new_polisi_sijil", :id => @course_implementation.id
      end
    else
      @course_implementation.cert_policy.update_attributes(params[:cert_policy])
      flash[:notice] = "Polisi berjaya dikemaskini."
      redirect_to :action => "new_polisi_sijil", :id => @course_implementation.id
    end
  end

  def set_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
  end

  def new_tarikh_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    #render layout: "standard-layout"
  end

  def new_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
  end

  def create_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    params[:sesi].size.times do |i|
      next if params[:sesi][i] == nil
      sesi_harian = SesiHarian.new
      sesi_harian.course_implementation_id = @course_implementation.id
      sesi_harian.tarikh = params[:sesi_harian][:tarikh]
      sesi_harian.session_code_id = params[:sesi][i]
      #sesi_harian.is_counted =
      begin
        sesi_harian.save
      rescue
        flash[:notice] = '<font color=red>Error. Sesi yang anda masukkan sudah wujud</font>'
        redirect_to("/course_management/#{@course_implementation.id}/new_tarikh_sesi") and return
      end
    end
    flash[:notice] = 'Sesi berjaya ditambah.'
    redirect_to("/course_management/#{@course_implementation.id}/new_tarikh_sesi")
  end

  def edit_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    #@sesi_harian = SesiHarian.find_all_by_tarikh(params[:sesi_harian][:tarikh])
    sql = "select sh.*, sc.time_in_text from sesi_harian as sh
               INNER JOIN session_codes as sc ON sc.id=sh.session_code_id
                   where sh.course_implementation_id=#{@course_implementation.id}
                   and sh.tarikh='#{params[:sesi_harian][:tarikh]}'
                   ORDER BY sc.time_start"
    @sesi_harian = SesiHarian.find_by_sql(sql)

  end

  def update_sesi
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    params[:session_code].each { |k, v|
      if v == nil
        sql = "delete from sesi_harian where id = #{k}"
        a = SesiHarian.find_by_sql(sql)
      else
        sql = "update sesi_harian set session_code_id = #{v} where id = #{k}"
        a = SesiHarian.find_by_sql(sql)
      end
    }
    flash[:notice] = 'Sesi berjaya dikemaskini.'
    redirect_to("/course_management/#{@course_implementation.id}/new_tarikh_sesi")
  end

  def catat_kehadiran
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9)order by name asc")
    else
      @students = []
    end
  end


  def new_cetak_kehadiran
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
  end

  def dmy(ymd_date, separator, new_separator)
    a = ymd_date.to_s.split(separator)
    b = "#{a[2]}#{new_separator}#{a[1]}#{new_separator}#{a[0]}"
    return b
  end

  def kehadiran_manual
    @course_implementation = CourseImplementation.find(params[:id])
    params[:orderby] = "personal_name" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]
    @arrow = params[:arrow]

    orderby = "name" if  @orderby == "personal_name"
    #@students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    @students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")

    sql = "select sh.*, sc.time_in_text from sesi_harian as sh
	       INNER JOIN session_codes as sc ON sc.id=sh.session_code_id
		   where sh.course_implementation_id=#{@course_implementation.id}
		   and sh.tarikh='#{params[:sesi_harian][:tarikh]}'
		   ORDER BY sc.time_start"
    @sesi_harian = SesiHarian.find_by_sql(sql)

    pdf = PDF::Writer.new(:paper => "A4", :orientation => :landscape)
    pdf.select_font("Helvetica")
    pdf.margins_mm(5)

    @font_size_normal = 9

    @font_size_large = 11
    pdf.text "<b>SENARAI KEHADIRAN", :font_size => @font_size_large, :justification => :center
    #put_text_center(10,"<b>KUTIPAN YURAN PENDAFTARAN</b>",13,pdf)
    pdf.text(" \n")
    #pdf.text(" \n")
    #pdf.text(" \n")

    @rujukan_font_size = 9
    pdf.add_text(60, pdf.y, "Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.course.name.upcase} (#{@course_implementation.code})", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Tarikh Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.tempoh_h}", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Tarikh Kehadiran", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, dmy(@sesi_harian[0].tarikh, "-", "/"), @rujukan_font_size)
    pdf.text(" \n")

    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 4th 5th 6th 7th 8th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "Bil"

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "Nama"
    table.columns["2nd"].heading.justification = :center

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "Kem./Jab./Agensi"
    table.columns["3rd"].heading.justification = :center

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "Gred"
    table.columns["4th"].heading.justification = :center

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "No. KP"
    table.columns["5th"].heading.justification = :center

    table.columns["6th"] = PDF::SimpleTable::Column.new("6th")
    table.columns["6th"].heading = "#{@sesi_harian[0].session_code.time_in_text}"
    table.columns["6th"].heading.justification = :center

    table.columns["7th"] = PDF::SimpleTable::Column.new("7th")
    table.columns["7th"].heading = "#{@sesi_harian[1].session_code.time_in_text}"
    table.columns["7th"].heading.justification = :center

    if @sesi_harian.size == 3
      table.columns["8th"] = PDF::SimpleTable::Column.new("8th")
      table.columns["8th"].heading = "#{@sesi_harian[2].session_code.time_in_text}"
      table.columns["8th"].heading.justification = :center

    else
      table.columns["8th"] = PDF::SimpleTable::Column.new("8th")
      table.columns["8th"].heading = " "
      table.columns["8th"].heading.justification = :center
    end
    table.show_lines = :all
    table.shade_rows = :none
    table.width = 700
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 9
    table.heading_font_size = 10

    data_all=[]
    jumlah = 0
    @students.each_with_index do |stu, idx|
      data = [
          #{"1st"=> idx+1 , "2nd"=> stu.profile.name, "3rd"=> stu.profile.ic_number, "4th"=> , "5th"=> , "6th"=> , "7th"=> , "8th"=> }
          {"1st" => idx+1, "2nd" => stu.profile.name + "\n  ", "3rd" => nof { stu.profile.opis.upcase }, "4th" => nof { stu.profile.employments.first.job_profile.job_grade }, "5th" => stu.profile.ic_number, "6th" => "", "7th" => "",
           "8th" => ""}
      ]
      #data["5th"].justification = :center
      data_all = data_all + data
    end

    table.data.replace data_all
    table.columns["6th"].justification = :center
    table.render_on(pdf)
    @font_size_normal = 9

    #pdf.save_as("#{RAILS_ROOT}/public/yuran/report.pdf")

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/yuran/" + "kehadiran.pdf") #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/yuran/" + "kehadiran.pdf") #kalu kat bsd
    end
    #redirect_to("/course_management/yuran/#{@course_implementation.id}?apply_status=yuran")
    redirect_to("/yuran/" + "kehadiran.pdf")

  end

  def kehadiran_manual_asal
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    sql = "select sh.*, sc.time_in_text from sesi_harian as sh
	       INNER JOIN session_codes as sc ON sc.id=sh.session_code_id
		   where sh.course_implementation_id=#{@course_implementation.id}
		   and sh.tarikh='#{params[:sesi_harian][:tarikh]}'
		   ORDER BY sc.time_start"
    @sesi_harian = SesiHarian.find_by_sql(sql)
    if @sesi_harian.size == 0
      render :text => '<font color=red>Sesi bagi tarikh ini belum disetkan. Sila set sesi terlebih dahulu.</font> <input type="button" value="OK" onclick="history.back()">' and return;
    end

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      @students = CourseApplication.find_by_sql("select p.name, ca.id,ca.profile_id from course_applications as ca join profiles as p on ca.profile_id=p.id where ca.course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9)order by name asc")
    else
      @students = []
    end

  end

  def new_catat_kehadiran
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
  end

  def masuk_data_kehadiran
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    #@sesi_harian = SesiHarian.find_all_by_tarikh(params[:sesi_harian][:tarikh])
    sql = "select sh.*, sc.time_in_text from sesi_harian as sh
               INNER JOIN session_codes as sc ON sc.id=sh.session_code_id
                   where sh.course_implementation_id=#{@course_implementation.id}
                   and sh.tarikh='#{params[:sesi_harian][:tarikh]}'
                   ORDER BY sc.time_start"
    @sesi_harian = SesiHarian.find_by_sql(sql)

    @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,p.name from course_applications as ca join profiles as p on ca.profile_id=p.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by name ASC")
  end

  def attendance
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]

      orderby = "name" if  @orderby == "personal_name"
      #@students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5)  order by #{orderby} #{@arrow}")
      @students = CourseApplication.find_by_sql("select ca.id,ca.profile_id,p.name from course_applications as ca join profiles as p on ca.profile_id=p.id where course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    else
      @students = []
    end
    #render layout: "standard-layout"
  end

  def create_attendance
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")

    i = 0
    if params[:att] == nil
      render :text => '<font color=red>Data kehadiran tidak dimasukkan. Sila klik pada checkbox yang berkenaan.</font> <input type="button" value="OK" onclick="history.back()">' and return;
    end
    #render :text=> params[:att].size and return;

    #delete first
    params[:att].each { |arr|
      student_id = arr[0]
      sesi = arr[1] #this is array
      sesi.each { |v|
        sql = "delete from attendances where course_implementation_id=#{@course_implementation.id}
				   and date_attend='#{params[:sesi_harian][:tarikh]}'
        " #and sesi_harian_id = #{v}"
        a = Attendance.find_by_sql(sql)
      }
      break;
    }

    params[:att].each { |arr|
      student_id = arr[0]
      sesi = arr[1] #this is array
      sesi.each { |v|
        @a = Attendance.new
        @a.course_implementation_id = @course_implementation.id
        @a.date_attend = params[:sesi_harian][:tarikh]
        @a.course_application_id = student_id
        @a.sesi_harian_id = v
        @a.save
      }
    }

    #redirect_to("/course_management/masuk_data_kehadiran/#{@course_implementation.id}?sesi_harian[tarikh]=#{params[:sesi_harian][:tarikh]}")
    redirect_to("/course_management/new_catat_kehadiran/#{@course_implementation.id}")
  end

  def maklumat_kehadiran
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
    @student = CourseApplication.find(params[:student_id])
    @employment = Employment.find_by_profile_id(@student.profile_id)
    @att = Attendance.find_all_by_course_application_id(params[:student_id])

    #sql = "select id from attendances where course_application_id=#{@student.id} and course_implementation_id=#{@course_implementation.id}"
    #@attends = Attendance.find_by_sql(sql)
    jumlah_hadir = @att.size
    return 0 if jumlah_hadir == 0
    patut_hadir = @course_implementation.sesi_harian.size
    a = (jumlah_hadir.to_f / patut_hadir.to_f) * 100
    @percent = a.floor
  end


  def gen_certificate_selected

  end

  def edit_surat_pengesahan
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
  end

  def edit_surat_takhadir
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")
  end

  def rujukan_kami
    @surats = SuratSahContent.find(:all, :conditions => "course_department_id = #{params[:id]}")
  end

  def jana_surat_pengesahan_pdf
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation
      #@students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
      @students = CourseApplication.where("course_implementation_id = ? AND student_status_id = ?", @course_implementation.id, 5).
                                    joins("LEFT JOIN profiles ON course_applications.profile_id = profiles.id
                                           LEFT JOIN states ON profiles.state_id = states.id").
                                    order("profiles.opis ASC").
                                    select("course_applications.*, profiles.opis as profile_opis, profiles.name as profile_name,
                                            profiles.hod as profile_hod, profiles.address1 as profile_address1,
                                            profiles.address2 as profile_address2, profiles.address3 as profile_address3,
                                            states.description as profile_state")
      @opis_collections = @students.map(&:profile_opis).uniq
    end

    rujukan = LatestApproveReference.find_by_course_department_id(@course_implementation.course.course_department_id)
    if rujukan
      rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
    else
      rujukan = LatestApproveReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => @course_implementation.course.course_department_id)
      rujukan.save
    end
    params[:surat_sah_content][:is_cetakan_komputer] = params[:is_cetakan_komputer]
    params[:surat_sah_content][:format_surat] = 1
    params[:surat_sah_content][:course_department_id] = @course_implementation.course.course_department_id
    params[:surat_sah_content][:course_implementation_id] = @course_implementation.id
    params[:surat_sah_content][:ref_no] = params[:rujukan_kami]
    params[:surat_sah_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]
    salinan_kepada = params[:salinan_kepada]

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "   " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
    #tarikh_surat = Time.new
    @tarikh = msian_date_very_formal(tarikh_surat)

    @perkara = params[:surat_sah_content][:perkara]
    @perenggan = params[:surat_sah_content][:perenggan]

    @signature = Signature.find_by_filename(params[:signature_file])
    if @signature
      @tandatangan_nama = @signature.person_name.upcase
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "         "
      @tandatangan_jawatan = "         "
    end

    @salinan_kepada = params[:salinan_kepada]

    #ads_letter = SuratSahContent.find_by_course_implementation_id(@course_implementation.id)
    #if ads_letter
    #  ads_letter.update_attributes(params[:surat_sah_content])
    #else
    #  new_ads_letter = SuratSahContent.new(params[:surat_sah_content])
    #  new_ads_letter.save!
    #end

    filename = "surat_sah_"+ "#{@course_implementation.id}.pdf"

    #pdf_surat_pengesahan(filename, @students)
    #redirect_to("/surat_pengesahan/" + filename)
    if RUBY_PLATFORM == "i386-mswin32"
      @signature_file = "public/signatures/#{params[:signature_file]}"
    else
      @signature_file = "/signatures/#{params[:signature_file]}"
    end

    if !params[:signature_file] or params[:signature_file] == ""
      @signature_file = ""
    end

    @format_surat = params[:is_cetakan_komputer].to_i

    if @format_surat == 2 || @format_surat == 3
      margin = { :top => 40, :left => 15, :bottom => 10, :right => 20 }
      #pdf.margins_pt(0, 50, 36, 50)
    else
      margin = { :top => 20, :left => 15, :bottom => 10, :right => 20 }
      #pdf.margins_pt(36, 50, 36, 50)
    end

    pdf_render_hash = {}
    pdf_render_hash[:pdf] = filename
    pdf_render_hash[:page_size] = 'A4'
    pdf_render_hash[:margin] = margin
    pdf_render_hash[:header] = {
        :html => {
            :template => 'layouts/header.pdf.erb',
            :locals => { :format_surat => @format_surat }
        },
        :spacing => 5
    } if @format_surat == 3 || @format_surat == 4

    respond_to do |format|
      format.html
      format.pdf do
        render pdf_render_hash
      end
    end
  end

  def jana_surat_takhadir_pdf
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation
      #@students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND (student_status_id=6 or student_status_id=4 )")
      @students = CourseApplication.where("course_implementation_id = ? AND (student_status_id = ? OR student_status_id = ?)", @course_implementation.id, 6, 4).
          joins("LEFT JOIN profiles ON course_applications.profile_id = profiles.id
                                           LEFT JOIN states ON profiles.state_id = states.id").
          order("profiles.opis ASC").
          select("course_applications.*, profiles.opis as profile_opis, profiles.name as profile_name,
                                            profiles.hod as profile_hod, profiles.address1 as profile_address1,
                                            profiles.address2 as profile_address2, profiles.address3 as profile_address3,
                                            states.description as profile_state")
      @opis_collections = @students.map(&:profile_opis).uniq
    end

    #rujukan = LatestApproveReference.find_by_course_department_id(@course_implementation.course.course_department_id)
    #if rujukan
    #	rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
    #else
    #	rujukan = LatestApproveReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => @course_implementation.course.course_department_id)
    #	rujukan.save
    #end

    params[:surat_sah_content][:is_cetakan_komputer] = params[:is_cetakan_komputer]
    params[:surat_sah_content][:format_surat] = 1
    params[:surat_sah_content][:course_department_id] = @course_implementation.course.course_department_id
    params[:surat_sah_content][:course_implementation_id] = @course_implementation.id
    params[:surat_sah_content][:ref_no] = params[:rujukan_kami]
    params[:surat_sah_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]
    #salinan_kepada = params[:salinan_kepada]

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "   " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
    #tarikh_surat = Time.new
    @tarikh = msian_date_very_formal(tarikh_surat)

    @perkara = params[:surat_sah_content][:perkara]
    @perenggan = params[:surat_sah_content][:perenggan]

    @signature = Signature.find_by_filename(params[:signature_file])
    if @signature
      @tandatangan_nama = @signature.person_name.upcase
      if @signature.person_position != ""
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "         "
      @tandatangan_jawatan = "         "
    end

    @salinan_kepada = params[:salinan_kepada]

    #ads_letter = SuratSahContent.find_by_course_implementation_id(@course_implementation.id)
    #if ads_letter
    #  ads_letter.update_attributes(params[:surat_sah_content])
    #else
    #  new_ads_letter = SuratSahContent.new(params[:surat_sah_content])
    #  new_ads_letter.save!
    #end

    filename = "surat_takhadir_"+ "#{@course_implementation.id}.pdf"

    #pdf_surat_pengesahan(filename, @students)
    #redirect_to("/surat_pengesahan/" + filename)

    if RUBY_PLATFORM == "i386-mswin32"
      @signature_file = "public/signatures/#{params[:signature_file]}"
    else
      @signature_file = "/signatures/#{params[:signature_file]}"
    end

    if !params[:signature_file] or params[:signature_file] == ""
      @signature_file = ""
    end

    @format_surat = params[:is_cetakan_komputer].to_i

    if @format_surat == 2 || @format_surat == 3
      margin = { :top => 40, :left => 15, :bottom => 10, :right => 20 }
      #pdf.margins_pt(0, 50, 36, 50)
    else
      margin = { :top => 20, :left => 15, :bottom => 10, :right => 20 }
      #pdf.margins_pt(36, 50, 36, 50)
    end

    pdf_render_hash = {}
    pdf_render_hash[:pdf] = filename
    pdf_render_hash[:page_size] = 'A4'
    pdf_render_hash[:margin] = margin
    pdf_render_hash[:header] = {
        :html => {
            :template => 'layouts/header.pdf.erb',
            :locals => { :format_surat => @format_surat }
        },
        :spacing => 5
    } if @format_surat == 3 || @format_surat == 4

    respond_to do |format|
      format.html
      format.pdf do
        render pdf_render_hash
      end
    end
  end

  def jana_sijil
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @course_implementation = CourseImplementation.find(params[:id]) if (params[:id] && params[:id] != "")

    if @course_implementation
      @students = CourseApplication.find(:all, :conditions => "course_implementation_id = #{@course_implementation.id} AND student_status_id=5")
    end

    filename = "sijil.pdf"
    gen_pdf_all(filename, @students)
    redirect_to("/pdf_certificate/" + filename)
  end

  def cetak_yuran
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    params[:orderby] = "personal_name" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]
    @arrow = params[:arrow]

    orderby = "name" if  @orderby == "personal_name"
    #@students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    @students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")

    pdf = PDF::Writer.new(:paper => "A4", :orientation => :landscape)
    pdf.select_font("Helvetica")
    pdf.margins_mm(5)

    @font_size_normal = 9
    pdf.text "Lampiran: A", :font_size => @font_size_normal, :justification => :right

    @font_size_large = 11
    pdf.text "<b>KUTIPAN YURAN PENDAFTARAN", :font_size => @font_size_large, :justification => :center
    #put_text_center(10,"<b>KUTIPAN YURAN PENDAFTARAN</b>",13,pdf)
    pdf.text(" \n")
    #pdf.text(" \n")
    #pdf.text(" \n")

    @rujukan_font_size = 9
    pdf.add_text(60, pdf.y, "Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.course.name.upcase} (#{@course_implementation.code})", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Tarikh Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.tempoh_h}", @rujukan_font_size)
    pdf.text(" \n")

    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 4th 5th 6th 7th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "Bil"

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "Nama"
    table.columns["2nd"].heading.justification = :center

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "No. K/P"
    table.columns["3rd"].heading.justification = :center

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "Kem./Jab./Agensi"
    table.columns["4th"].heading.justification = :center

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "Tandatangan"
    table.columns["5th"].heading.justification = :center

    table.columns["6th"] = PDF::SimpleTable::Column.new("6th")
    table.columns["6th"].heading = "Tarikh"
    table.columns["6th"].heading.justification = :center

    table.columns["7th"] = PDF::SimpleTable::Column.new("7th")
    table.columns["7th"].heading = "Bayaran\n(RM)"
    table.columns["7th"].heading.justification = :center


    table.show_lines = :all
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 9
    table.heading_font_size = 10

    data_all=[]
    jumlah = 0
    @students.each_with_index do |stu, idx|
      data = [
          #{"1st"=> idx+1 , "2nd"=> stu.profile.name, "3rd"=> stu.profile.ic_number, "4th"=> , "5th"=> , "6th"=> , "7th"=> , "8th"=> }
          {"1st" => idx+1, "2nd" => stu.profile.name, "3rd" => stu.profile.ic_number, "4th" => nof { stu.profile.opis.upcase }, "5th" => "", "6th" => nof { stu.payment_date.to_formatted_s(:my_format_4) }, "7th" => stu.fee_amount.to_i}
      ]
      #data["5th"].justification = :center
      data_all = data_all + data
      stu.fee_amount = 0 if stu.fee_amount == nil
      jumlah += stu.fee_amount
    end
    data_all= data_all + [{"2nd" => "JUMLAH BESAR :", "7th" => jumlah.to_i}]

    table.data.replace data_all
    table.columns["6th"].justification = :center
    table.render_on(pdf)
    @font_size_normal = 9

    ##################################
    @dotdot = "......................................"
    @rujukan_font_size = 10
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Dikutip oleh (Penyelaras Kursus)", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Nama", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Jawatan", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.y = pdf.y + 115
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(400, pdf.y, "Diterima oleh (Seksyen Kewangan)", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(410, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(470, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(480, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(410, pdf.y, "Nama", @rujukan_font_size)
    pdf.add_text(470, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(480, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(410, pdf.y, "Jawatan", @rujukan_font_size)
    pdf.add_text(470, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(480, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(410, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(470, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(480, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")


    ###################################

    #pdf.save_as("#{RAILS_ROOT}/public/yuran/report.pdf")

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/yuran/" + "report.pdf") #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/yuran/" + "report.pdf") #kalu kat bsd
    end
    #redirect_to("/course_management/yuran/#{@course_implementation.id}?apply_status=yuran")
    redirect_to("/yuran/" + "report.pdf")

  end

  def cetak_yuran_asal
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    params[:orderby] = "personal_name" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]
    @arrow = params[:arrow]

    orderby = "name" if  @orderby == "personal_name"
    #@students = CourseApplication.find_by_sql("select * from profiles join course_applications on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")
    @students = CourseApplication.find_by_sql("select * from course_applications join profiles on course_applications.profile_id=profiles.id WHERE course_implementation_id = #{@course_implementation.id} AND (student_status_id=5 OR student_status_id=8 OR student_status_id=9) order by #{orderby} #{@arrow}")


    pdf = PDF::Writer.new(:paper => "A4")
    pdf.select_font("Helvetica")
    pdf.margins_mm(20)

    @font_size_normal = 10
    pdf.text "Lampiran 7", :font_size => @font_size_normal, :justification => :right

    put_text_center(10, "<b>INSTITUT TANAH DAN UKUR NEGARA (INSTUN)</b>", 13, pdf)
    put_text_center(30, "<b>BORANG YURAN PENDAFTARAN PESERTA</b>", 13, pdf)

    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.text(" \n")

    ##############33
    @rujukan_font_size = 9
    pdf.add_text(60, pdf.y, "Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.course.name.upcase} (#{@course_implementation.code})", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Tarikh Kursus", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.tempoh_h}", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Penyelaras", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.penyelaras1.profile.name}", @rujukan_font_size)
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Penyelaras", @rujukan_font_size)
    pdf.add_text(140, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(160, pdf.y, "#{@course_implementation.penyelaras2.profile.name}", @rujukan_font_size)

    pdf.text(" \n")

    ###############3


    table = PDF::SimpleTable.new
    table.column_order.push(*%w(1st 2nd 3rd 5th 6th 7th))

    table.columns["1st"] = PDF::SimpleTable::Column.new("1st")
    table.columns["1st"].heading = "Bil"

    table.columns["2nd"] = PDF::SimpleTable::Column.new("2nd")
    table.columns["2nd"].heading = "Nama"
    table.columns["2nd"].heading.justification = :center

    table.columns["3rd"] = PDF::SimpleTable::Column.new("3rd")
    table.columns["3rd"].heading = "No. K/P"
    table.columns["3rd"].heading.justification = :center

    table.columns["4th"] = PDF::SimpleTable::Column.new("4th")
    table.columns["4th"].heading = "Kementerian/Jabatan"

    table.columns["5th"] = PDF::SimpleTable::Column.new("5th")
    table.columns["5th"].heading = "Tarikh"
    table.columns["5th"].heading.justification = :center

    table.columns["6th"] = PDF::SimpleTable::Column.new("6th")
    table.columns["6th"].heading = "	 Bayaran\n(RM)"
    table.columns["6th"].heading.justification = :center

    table.columns["7th"] = PDF::SimpleTable::Column.new("7th")
    table.columns["7th"].heading = "Tandatangan"


    table.show_lines = :all
    table.show_headings = true
    table.orientation = :center
    table.position = :center
    table.font_size = 9
    table.heading_font_size = 10

    data_all=[]
    jumlah = 0
    @students.each_with_index do |stu, idx|
      data = [
          #{"1st"=> idx+1 , "2nd"=> stu.profile.name, "3rd"=> stu.profile.ic_number, "4th"=> , "5th"=> , "6th"=> , "7th"=> , "8th"=> }
          {"1st" => idx+1, "2nd" => stu.profile.name, "3rd" => stu.profile.ic_number, "4th" => stu.profile.opis.upcase, "5th" => nof { stu.payment_date.to_formatted_s(:my_format_4) }, "6th" => stu.fee_amount.to_i}
      ]
      #data["5th"].justification = :center
      data_all = data_all + data
      stu.fee_amount = 0 if stu.fee_amount == nil
      jumlah += stu.fee_amount
    end
    data_all= data_all + [{"2nd" => "JUMLAH :", "6th" => jumlah.to_i}]

    table.data.replace data_all
    table.columns["6th"].justification = :center
    table.render_on(pdf)
    @font_size_normal = 9

    pdf.text(" \n")
    pdf.text(" \n")

    ##################################
    @dotdot = "......................................"
    @rujukan_font_size = 10
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(60, pdf.y, "Dikutip oleh", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Nama", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Jawatan", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(70, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(130, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(140, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")

    pdf.y = pdf.y + 115
    pdf.add_text(300, pdf.y, "Diterima oleh", @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(310, pdf.y, "Tandatangan", @rujukan_font_size)
    pdf.add_text(370, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(380, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(310, pdf.y, "Nama", @rujukan_font_size)
    pdf.add_text(370, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(380, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(310, pdf.y, "Jawatan", @rujukan_font_size)
    pdf.add_text(370, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(380, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")
    pdf.text(" \n")
    pdf.add_text(310, pdf.y, "Tarikh", @rujukan_font_size)
    pdf.add_text(370, pdf.y, ":", @rujukan_font_size)
    pdf.add_text(380, pdf.y, @dotdot, @rujukan_font_size)
    pdf.text(" \n")


    ###################################

    #pdf.save_as("#{RAILS_ROOT}/public/yuran/report.pdf")

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/yuran/" + "report.pdf") #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/yuran/" + "report.pdf") #kalu kat bsd
    end
    #redirect_to("/course_management/yuran/#{@course_implementation.id}?apply_status=yuran")
    redirect_to("/yuran/" + "report.pdf")

  end


  private
  def gen_pdf_all (file, students)

    pdf = PDF::Writer.new(:paper => "A4")
    pdf.select_font("Times-Roman")
    #pdf.select_font("Helvetica")

    #@certificates = Certificate.find(params[:certificate_ids])

    i = 0
    for student in students

      certificate = student.certificate

      #next if student.certificate.is_qualified == 0

      #pdf.image "public/images/header_install.png", :justification => :center

      pdf.select_font("Times-Italic")
      generate_pattern_kehadiran(student, pdf)

      i = i + 1
      pdf.new_page if (i != students.size)

    end

    #pdf.save_as("public/pdf_certificate/" + file)
    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/pdf_certificate/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/pdf_certificate/" + file) #kalu kat bsd
    end

  end


  private
  def generate_pattern_kehadiran(student, pdf)
    nric = "#{student.profile.ic_number[0, 6]}-#{student.profile.ic_number[6, 2]}-#{student.profile.ic_number[8, 4]}  "

    #pdf.add_image_from_file("public/images/hd3.jpg",160,697)
    #pdf.add_image_from_file("public/images/pbtpg-s.jpg",370,700)

    pdf.select_font("Times-Italic")
    put_text_center(70, "Sijil Penyertaan", 40, pdf)
    put_text_center(140, "Dengan ini disahkan", 18, pdf)
    pdf.select_font "Times-Roman"
    put_text_center(180, "#{student.profile.name.upcase}", 24, pdf)
    put_text_center(200, "#{nric}", 20, pdf)
    pdf.select_font("Times-Italic")
    put_text_center(250, "Telah menghadiri ", 13, pdf)
    pdf.select_font "Times-Bold"
    put_text_center(280, "#{student.course.name.upcase}", 20, pdf)
    pdf.select_font "Times-Italic"
    put_text_center(320, "yang dianjurkan oleh", 13, pdf)
    pdf.select_font "Times-Roman"
    put_text_center(340, "INSTITUT TANAH DAN UKUR NEGARA", 15, pdf)
    pdf.select_font "Times-Roman"
    put_text_center(360, "(INSTUN)", 13, pdf)
    pdf.select_font "Times-Italic"
    put_text_center(420, "pada", 13, pdf)
    pdf.select_font "Times-Roman"
    put_text_center(440, "#{student.course_implementation.tempoh_2.upcase}", 13, pdf)
    pdf.select_font "Times-Italic"
    put_text_center(480, "bertempat", 13, pdf)
    pdf.select_font "Times-Roman"
    put_text_center(500, "INSTITUT TANAH DAN UKUR NEGARA", 13, pdf)
    put_text_center(515, "KEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR", 13, pdf)
    put_text_center(530, "BEHRANG, 35950 TANJONG MALIM", 13, pdf)
    put_text_center(545, "PERAK DARUL RIDZUAN", 13, pdf)
    put_text_center(560, "", 13, pdf)
    put_text_center(575, "", 13, pdf)
    pdf.y = pdf.absolute_top_margin - (525 + 50 + 100)
    pdf.select_font "Times-Roman"
    pdf.text "Ketua Setiausaha			     ", :font_size => 9, :justification => :right
    pdf.text "Kementerian Sumber Asli dan Alam Sekitar ", :font_size => 9, :justification => :right

    pdf.text "\n\n\n\nPengarah				 ", :font_size => 9, :justification => :right
    pdf.text "Institut Tanah dan Ukur Negara	      ", :font_size => 9, :justification => :right

  end

  def put_text_center(y, t, s, pdf)
    #s = 28 #font size
    w = pdf.text_width(t, s) / 2.0
    x = pdf.margin_x_middle
    y = pdf.absolute_top_margin - (50+y)
    pdf.add_text(x - w, y, t, s)
  end

  private
  def pdf_surat_pengesahan (file, students)

    if RUBY_PLATFORM == "i386-mswin32"
      header_image = "public/images/header800.jpg"
      footer_image = "public/images/footer800.jpg"
    else
      header_image = "/aplikasi/www/instun/public/images/header800.jpg"
      footer_image = "/aplikasi/www/instun/public/images/footer800.jpg"
    end

    @font_size = 11
    @font_size_small = 10
    @tajuk_font_size = 11

    pdf = PDF::Writer.new(:paper => "A4")
    pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
    @my_margin = pdf.absolute_top_margin - 40
    pdf.select_font("Helvetica")

    i = 1
                                   #@students = CourseApplication.find(params[:course_application_ids])
    for student in @students

      #header
      if (params[:is_cetakan_komputer].to_i == 3) or params[:is_cetakan_komputer].to_i == 2
        pdf.add_image_from_file(header_image, 0, 730, 600, nil)
      end

      #footer
      if (params[:is_cetakan_komputer].to_i == 3) or params[:is_cetakan_komputer].to_i == 2
        pdf.add_image_from_file(footer_image, 0, 0, 600, nil)
      end

      pdf.text "", :font_size => @font_size, :justification => :left

      @rujukan_kami = params[:rujukan_kami]
      @tarikh_surat_day = params[:tarikh_surat_day]
      @tarikh_surat_day = "   " if params[:tarikh_surat_day] == ""
      @tarikh_surat_month = params[:tarikh_surat_month]
      @tarikh_surat_year = params[:tarikh_surat_year]

      tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
      #tarikh_surat = Time.new
      @tarikh = msian_date_very_formal(tarikh_surat)
      employment = Employment.find_by_profile_id(student.profile.id)
      if employment and employment.job_profile
        job_name = nof { employment.job_profile.job_name }
        job_name = employment.job_profile.job_name.split(" ").map! { |e| e.capitalize }.join(" ") if @job_name != nil
        job_grade = nof { employment.job_profile.job_grade }
        @job_profile = "#{job_name} #{job_grade}"
      else
        @job_profile = " "
      end

      @perkara = params[:surat_sah_content][:perkara]
      @perenggan1 = params[:surat_sah_content][:perenggan1]
      #@perenggan2 = params[:surat_sah_content][:perenggan2]
      baris1 = "Sukacita dimaklumkan bahawa pegawai berikut telah menghadiri kursus di atas yang dianjurkan oleh Institut Tanah dan Ukur Negara (INSTUN)."
      baris2 = "\n           Nama: #{student.profile.name}"
      baris3 = "           Jawatan: #{@job_profile}"
      baris_arr = Array.new
      baris_arr.push(baris1)
      baris_arr.push(baris2)
      baris_arr.push(baris3)
      perkara_arr = baris_arr.join("\n")
      @perenggan2 = "2.     #{perkara_arr}"
      @perenggan3 = "3.     #{params[:surat_sah_content][:perenggan3]}"
      @perenggan4 = "4.     #{params[:surat_sah_content][:perenggan4]}"
      @perenggan5 = params[:surat_sah_content][:perenggan5]
      salinan_kepada = params[:salinan_kepada]

      if (student.profile.address1 != nil) && (student.profile.state != nil)
        p_addr1 = student.profile.address1.split(" ").map! { |e| e }.join(" ")
        p_addr2 = student.profile.address2.split(" ").map! { |e| e }.join(" ")
        p_addr3 = student.profile.address3.split(" ").map! { |e| e }.join(" ")
        p_state = student.profile.state.description.split(" ").map! { |e| e.capitalize }.join(" ")

        p_addr_arr = Array.new
        p_addr_arr.push(p_addr1) if student.profile.address1 != ""
        p_addr_arr.push(p_addr2) if student.profile.address2 != ""
        p_addr_arr.push(p_addr3) if student.profile.address3 != ""
        p_addr_arr.push(p_state.upcase) if student.profile.state != ""
        p_addr = p_addr_arr.join("\n")
        p_addr = p_addr.tr_s(',', ',')
      else
        p_addr_arr = Array.new
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr_arr.push(" ")
        p_addr = p_addr_arr.join(" \n")
      end

      ketua = "#{student.profile.hod}"
      office_name = "#{student.profile.opis}"
      p_alamat = "#{p_addr}"

      @signature = Signature.find_by_filename(params[:signature_file])
      if @signature
        @tandatangan_nama = @signature.person_name.upcase
        if @signature.person_position != ""
          @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
        else
          @tandatangan_jawatan = ""
        end
      else
        @tandatangan_nama = "         "
        @tandatangan_jawatan = "         "
      end

      pdf.y = @my_margin -50
      pdf.add_text(345, pdf.y, "Ruj. Tuan", @tajuk_font_size)
      pdf.add_text(395, pdf.y, ": ", @tajuk_font_size)
      pdf.text "\n", :font_size => @tajuk_font_size
      pdf.add_text(345, pdf.y, "Ruj. Kami", @tajuk_font_size)
      pdf.add_text(395, pdf.y, ":", @tajuk_font_size)
      pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @tajuk_font_size)
      pdf.text "\n", :font_size => @tajuk_font_size
      pdf.add_text(345, pdf.y, "Tarikh", @tajuk_font_size)
      pdf.add_text(395, pdf.y, ":", @tajuk_font_size)
      pdf.add_text(405, pdf.y, "#{@tarikh}", @tajuk_font_size)

      pdf.text "\n\n#{ketua}", :font_size => @font_size_small, :justification => :left
      pdf.text "#{office_name}", :font_size => @font_size_small, :justification => :left
      pdf.text "#{p_alamat}", :font_size => @font_size_small, :justification => :left

      pdf.text "\n", :font_size => @font_size, :justification => :center
      pdf.text "Tuan/Puan,\n", :font_size => @font_size, :justification => :left
      pdf.text "\n", :font_size => @font_size, :justification => :center
      @per_lines = @perkara.split("\n")
      for per_line in @per_lines
        pdf.text "<b>#{per_line}</b>", :font_size => @tajuk_font_size, :justification => :left
      end

      pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :left
      pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
      pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
      pdf.text "\n", :font_size => @font_size

      pdf.text "Sekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n", :font_size => @font_size, :justification => :left
      pdf.text "<b>'MS ISO 9001:2008 - PENGURUSAN LATIHAN'</b>\n\n", :font_size => @font_size, :justification => :left
      pdf.text "Saya yang menurut perintah,\n", :font_size => @font_size, :justification => :left
      if (params[:is_cetakan_komputer].to_i == 0) or params[:is_cetakan_komputer].to_i == 3
        if RUBY_PLATFORM == "i386-mswin32"
          @signature_file = "public/signatures/#{params[:signature_file]}"
        else
          @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
        end

        if params[:signature_file] and params[:signature_file] != ""
          pdf.image @signature_file, :resize => 0.4
        else
          pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left
        end
      end

      pdf.text "<b>(#{@tandatangan_nama})</b>", :font_size => @tajuk_font_size, :justification => :left
      pdf.text "#{@tandatangan_jawatan}\n", :font_size => @tajuk_font_size, :justification => :left
      if @tandatangan_nama != "DATO' HAJI MOHD SHAFIE BIN ARIFIN"
        pdf.text "b.p Pengarah INSTUN", :font_size => @font_size, :justification => :left
      end

      pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @tajuk_font_size, :justification => :left
      pdf.text "Kementerian Sumber Asli dan Alam Sekitar\n", :font_size => @tajuk_font_size, :justification => :left

      pdf.text "\ns.k", :font_size => @font_size, :justification => :left
      sk_lines = salinan_kepada.split("\n")
      for sk_line in sk_lines
        pdf.add_text(100, pdf.y, "#{sk_line}", @font_size)
        pdf.text "\n", :font_size => @font_size
      end

      @nota_font_size = 9
      current_y = pdf.y
      pdf.y = pdf.absolute_bottom_margin + 30
      if params[:is_cetakan_komputer].to_i==1 or params[:is_cetakan_komputer].to_i==2
        pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size)
      end

      pdf.new_page if i < @students.size
      i = i+1
      pdf.y = @my_margin

    end # @students loop

    if RUBY_PLATFORM == "i386-mswin32"
      pdf.save_as("public/surat_pengesahan/" + file) #kat windows
    else
      pdf.save_as("/aplikasi/www/instun/public/surat_pengesahan/" + file) #kalu kat bsd
    end

  end


end
