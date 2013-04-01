class ReportTablesController < ApplicationController
  layout "standard-layout"
  def application_and_attendance
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from date_apply)as year from vw_detailed_applicants_all").collect(&:year)
 
    if params[:month_from].present? && params[:month_until].present? && params[:year].present?
      filter = "AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}"
      filter2 = "AND EXTRACT(month FROM ci.date_apply_start) >= #{params[:month_from]} AND EXTRACT(month FROM ci.date_apply_start) <= #{params[:month_until]} AND EXTRACT(year FROM ci.date_apply_start) = #{params[:year]}"

      sql = "select ci.code as code, c.name as course_name, (
        select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id = ci.id	AND student_status_id IN (4,5,6,8,9,7,2) #{filter}) as pemohon,
        (select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id = ci.id	AND student_status_id IN (2) #{filter}) as dipilih,
        (select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id = ci.id	AND student_status_id IN (5,8,9) #{filter}) as hadir
      FROM course_implementations ci, courses c
      WHERE ci.course_id = c.id #{filter2}
        "
      @reports =  CourseApplication.find_by_sql(sql)
    else
      flash[:notice] = "sila isi filter dengan lengkap" if params[:month_from].present? || params[:month_until].present? || params[:year].present?
      @reports =  []
    end
    #@reports =  CourseApplication.paginate_by_sql(sql, :page => params[:page], :per_page => 20 )
  end

  def peserta_mengikuti_jabatan
    
  end
end