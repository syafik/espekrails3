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
    #p_tanah_ids =
    place_p_tanah_children_ids = []
    place_p_tanah_rows = Place.where("id =307 OR (name ilike '%JABATAN KETUA PENGARAH TANAH DAN GALIAN (JKPTG)%' OR name ilike '%galian%' OR name ilike '%tanah%' AND place_type_id = 1)")
    place_p_tanah_rows.each do |place_p_tanah_row|
      if place_p_tanah_row.id != 307
        place_p_tanah_children_ids += place_p_tanah_row.children.collect(&:id)
      end
    end
    place_p_tanah_ids = (place_p_tanah_rows.collect(&:id) + place_p_tanah_children_ids).uniq

    place_jupem_children_ids = []
    place_jupem_rows = Place.where("id =307 OR (name ilike '%JABATAN KETUA PENGARAH TANAH DAN GALIAN (JKPTG)%' OR name ilike '%galian%' OR name ilike '%tanah%' AND place_type_id = 1)")
    place_jupem_rows.each do |place_jupem_row|
      if place_jupem_row.id != 307
        place_jupem_children_ids += place_jupem_row.children.collect(&:id)
      end
    end
    place_jupem_ids = (place_jupem_rows.collect(&:id) + place_jupem_children_ids).uniq

    sql_1_1 ="SELECT count(*) FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'T%' AND code NOT LIKE 'TM%')
    AND profile_id IN (
      select e.profile_id from employments e, profiles p where p.id = e.profile_id AND e.place_id IN (#{place_p_tanah_ids.join(",")}))
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
    "

    sql_1_2 = ""
  end

  def peserta_jantina
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from date_apply)as year from vw_detailed_applicants_all").collect(&:year)
 
    if params[:month_from].present? && params[:month_until].present? && params[:year].present?
      sql_1_male ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'T%' AND code NOT LIKE 'TM%')
    AND profile_id IN (
      select id from profiles p where gender_id = 1 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_1_female ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'T%' AND code NOT LIKE 'TM%')
    AND profile_id IN (
      select id from profiles p where gender_id = 2 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_2_male ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'U%')
    AND profile_id IN (
      select id from profiles p where gender_id = 1 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_2_female ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'U%')
    AND profile_id IN (
      select id from profiles p where gender_id = 2 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_3_male ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'TM%')
    AND profile_id IN (
      select id from profiles p where gender_id = 1 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_3_female ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code LIKE 'TM%')
    AND profile_id IN (
      select id from profiles p where gender_id = 2 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_4_male ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code NOT LIKE 'T%' AND code NOT LIKE 'TM%' AND code NOT LIKE 'U%')
    AND profile_id IN (
      select id from profiles p where gender_id = 1 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "

      sql_4_female ="SELECT count(*) as total FROM course_applications WHERE course_implementation_id IN
    (Select id from course_implementations where code NOT LIKE 'T%' AND code NOT LIKE 'TM%' AND code NOT LIKE 'U%')
    AND profile_id IN (
      select id from profiles p where gender_id = 2 )
    AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}
      "
      cat_1_male = CourseApplication.find_by_sql(sql_1_male)
      cat_1_female = CourseApplication.find_by_sql(sql_1_female)
      cat_2_male = CourseApplication.find_by_sql(sql_2_male)
      cat_2_female = CourseApplication.find_by_sql(sql_2_female)
      cat_3_male = CourseApplication.find_by_sql(sql_3_male)
      cat_3_female = CourseApplication.find_by_sql(sql_3_female)
      cat_4_male = CourseApplication.find_by_sql(sql_4_male)
      cat_4_female = CourseApplication.find_by_sql(sql_4_female)

      @reports = [
        {:id=> 1, :name => "Pentadbiran Tanah", :male => cat_1_male[0].total, :female => cat_1_female[0].total},
        {:id=> 2, :name => "Ukur dan Pemetaan", :male => cat_2_male[0].total, :female => cat_2_female[0].total},
        {:id=> 3, :name => "Teknologi Maklumat", :male => cat_3_male[0].total, :female => cat_3_female[0].total},
        {:id=> 4, :name => "Lain-lain", :male => cat_4_male[0].total, :female => cat_4_female[0].total}
      ]
    else
      @reports=[]
    end
  end

end