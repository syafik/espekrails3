class ReportTablesController < ApplicationController
  layout "standard-layout"
  before_filter :prepare_and_check_month_data, :except => [:application_and_attendance_query]
  
  def application_and_attendance 
    if is_param_month_range_valid?
      filter = "AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}"

      condition_1 = "Select id from course_implementations where code LIKE 'T%' AND code NOT LIKE 'TM%'"
      condition_2 = "Select id from course_implementations where code LIKE 'U%'"
      condition_3 = "Select id from course_implementations where code LIKE 'TM%'"
      result_1 = application_and_attendance_query('Pentadbiran Tanah', condition_1, filter)
      result_2 = application_and_attendance_query('Ukur dan Pemetaan', condition_2, filter)
      result_3 = application_and_attendance_query('Teknologi Maklumat', condition_3, filter)
      @reports = result_1 + result_2 + result_3
    end  
  end

  def peserta_mengikut_jabatan 
    if params[:month_from].present? && params[:month_until].present? && params[:year].present?
      filter = " WHERE EXTRACT(month FROM date_apply) >= #{params[:month_from]}
                 AND EXTRACT(month FROM date_apply) <= #{params[:month_until]}
                 AND EXTRACT(year FROM date_apply) = #{params[:year]}"

      condition_1 = "Select id from course_implementations where code LIKE 'T%' AND
       code NOT LIKE 'TM%'"
      condition_2 = "Select id from course_implementations where code LIKE 'U%'"
      condition_3 = "Select id from course_implementations where code LIKE 'TM%'"
    
      place_p_tanah_children_ids = []
      place_p_tanah_rows = Place.where("id =307 OR (name ilike '%JABATAN KETUA PENGARAH TANAH DAN GALIAN (JKPTG)%' OR name ilike '%galian%' OR name ilike '%tanah%') AND code NOT IN ('1010000006', '1011250000', '2037110000', '1365080000', '101125')")
      place_p_tanah_rows.each do |place_p_tanah_row|
        if place_p_tanah_row.id != 307
          place_p_tanah_children_ids += place_p_tanah_row.children.collect(&:id)
        end
      end
      place_p_tanah_ids = (place_p_tanah_rows.collect(&:id) + place_p_tanah_children_ids).uniq

      place_jupem_children_ids = []
      place_jupem_rows = Place.where("name ilike '%JABATAN UKUR DAN PEMETAAN MALAYSIA (JUPEM)%'")
      place_jupem_rows.each do |place_jupem_row|
        if place_jupem_row.id != 307
          place_jupem_children_ids += place_jupem_row.children.collect(&:id)
        end
      end
      place_jupem_ids = (place_jupem_rows.collect(&:id) + place_jupem_children_ids).uniq

      place_other_ids = (Place.all.collect(&:id) - (place_p_tanah_ids + place_jupem_ids)).uniq

      result_1 = peserta_mengikut_jabatan_query('Pentadbiran Tanah', condition_1, place_p_tanah_ids, place_jupem_ids, place_other_ids, filter)
      result_2 = peserta_mengikut_jabatan_query('Ukur dan Pemetaan', condition_2, place_p_tanah_ids, place_jupem_ids, place_other_ids, filter)
      result_3 = peserta_mengikut_jabatan_query('Teknologi Maklumat', condition_3, place_p_tanah_ids, place_jupem_ids, place_other_ids, filter)

      @reports = result_1 + result_2 + result_3
    else
      flash[:notice] = "sila isi filter dengan lengkap" if params[:month_from].present? || params[:month_until].present? || params[:year].present?
      @reports =  []
    end
  end

  def summary_group_by_states
    if is_param_month_range_valid?
          
      presence_total_query = "select count(vdaa.profile_id) as total
        FROM vw_detailed_applicants_all vdaa 
        WHERE student_status_id IN (5,8,9) 
        AND UPPER(OPIS) LIKE ('JKPTG%') OR OPIS LIKE('JABATAN KETUA PENGARAH TANAH DAN GALIAN%')
        AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
        AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
        AND EXTRACT(year FROM date_apply) = #{params[:year]}"

      total = CourseApplication.find_by_sql(presence_total_query)[0][:total].to_i  
     
      group_query = "select count(vdaa.profile_id) as subtotal, ((cast (count(vdaa.profile_id) as float)) / #{total.to_i})*100 as percentage, pr.state_id, st.description as state_name
              FROM vw_detailed_applicants_all vdaa
              join profiles pr on vdaa.profile_id = pr.id
              join states st on pr.state_id = st.id
              WHERE student_status_id IN (5,8,9)
              AND UPPER(vdaa.OPIS) LIKE ('JKPTG%') OR UPPER(vdaa.OPIS) LIKE('JABATAN KETUA PENGARAH TANAH DAN GALIAN%')
              AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
              AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
              AND EXTRACT(year FROM date_apply) = #{params[:year]}
              group by state_id, st.description
              order by st.description asc"              
              
      @reports =  CourseApplication.find_by_sql(group_query)      
    end
  end
  
  def summary_group_jupem
    if is_param_month_range_valid?
    
      presence_total_query = "select count(vdaa.profile_id) as total
        FROM vw_detailed_applicants_all vdaa 
        WHERE student_status_id IN (5,8,9)
        AND UPPER(OPIS) LIKE('JABATAN UKUR DAN PEMETAAN MALAYSIA%') OR UPPER(OPIS) LIKE ('JUPEM%')        
        AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
        AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
        AND EXTRACT(year FROM date_apply) = #{params[:year]}"

      total = CourseApplication.find_by_sql(presence_total_query)[0][:total].to_i  
     
      group_query = "select count(vdaa.profile_id) as subtotal, ((cast (count(vdaa.profile_id) as float)) / #{total.to_i})*100 as percentage, pr.state_id, st.description as state_name
              FROM vw_detailed_applicants_all vdaa
              join profiles pr on vdaa.profile_id = pr.id
              join states st on pr.state_id = st.id
              WHERE student_status_id IN (5,8,9)
              AND UPPER(vdaa.OPIS) LIKE('JABATAN UKUR DAN PEMETAAN MALAYSIA%') OR UPPER(vdaa.OPIS) LIKE ('JUPEM%')        
              AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
              AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
              AND EXTRACT(year FROM date_apply) = #{params[:year]}
              group by state_id, st.description, vdaa.opis
              having vdaa.opis = 'JABATAN UKUR DAN PEMETAAN MALAYSIA'
              order by st.description asc"              
              
      @reports =  CourseApplication.find_by_sql(group_query)      
    end
  end
  
  def peserta_jantina     
    if is_param_month_range_valid?    
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
    end
  end

  def trainer_by_department
    total_all = Trainer.find_by_sql("select count(*) as amount from trainers t, profiles p where t.profile_id = p.id")[0].amount.to_i
    total_internal_but_no_department = Trainer.find_by_sql("SELECT count(*) as amount FROM trainers t, profiles p WHERE t.profile_id = p.id AND t.is_internal = 1 AND course_department_id is NULL")[0].amount.to_i
    total = total_all - total_internal_but_no_department
    #raise total.inspect
    sql = []
    sql[0] = "SELECT 'Pengurusan dan Perundangan Tanah' AS name, (
      SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 1) AS amount,
      (cast ((SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 1) as float) / #{total}*100) as percentage"
    sql[1] = "SELECT 'Ukur dan Pemetaan' AS name, (
      SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 1) AS amount,
      (cast ((SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 1) as float) / #{total}*100) as percentage"
    sql[2] = "SELECT 'Teknologi Maklumat' AS name, (
      SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 1) AS amount,
      (cast ((SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 1) as float) / #{total}*100) as percentage"
    sql[3] = "SELECT 'Pentadbiran dan Kewangan' AS name, (
      SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 1) AS amount,
      (cast ((SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 1) as float) / #{total}*100) as percentage"
    sql[4] = "SELECT 'Luaran' AS name, (
      SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND (t.is_internal = 0 OR t.is_internal IS NULL)) AS amount,
      (cast ((SELECT count(*) FROM trainers t, profiles p
      WHERE t.profile_id = p.id AND (t.is_internal = 0 OR t.is_internal IS NULL)) as float) / #{total}*100) as percentage"

    @reports = []
    sql.each do |i|
      @reports += Trainer.find_by_sql(i)
    end
  end

  private

  def prepare_and_check_month_data
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from date_apply)as year from vw_detailed_applicants_all").collect(&:year)
  end

  def is_param_month_range_valid?
    if !params[:month_from].present? && !params[:month_until].present? && !params[:year].present?
      flash[:notice] = "sila isi filter dengan lengkap" if params[:month_from].present? || params[:month_until].present? || params[:year].present?
      @reports =  []
      false
    else
      true
    end
  end

  def application_and_attendance_query(title, condition, filter)
    sql = "select '#{title}' as name, (
        select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id IN (
          #{condition})
        AND student_status_id IN (4,5,6,8,9,7,2) #{filter}) as pemohon,
        (select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id IN (
          #{condition})
        AND student_status_id IN (2) #{filter}) as dipilih,
        (select count(*)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id IN (
          #{condition})
        AND student_status_id IN (5,8,9) #{filter}) as hadir
    "
    return CourseApplication.find_by_sql(sql)
  end

  def peserta_mengikut_jabatan_query(title, condition, ids1, ids2, ids3, filter)
    result = OpenStruct.new
    result.name = title
    result.p_tanah = custom_filter(condition, ids1, filter).to_s
    result.jupem   = custom_filter(condition, ids2, filter).to_s
    result.other   = custom_filter(condition, ids3, filter).to_s

    return [result]         
  end
  
  def custom_filter(condition, ids, filter)
    a = "select course_implementation_id as cid, profile_id as pid FROM course_applications #{filter}"
    rows = CourseApplication.find_by_sql(a)
    
    #filter 1 course_implementation.id
    cids = CourseImplementation.find_by_sql(condition)      
    cids = cids.collect(&:id).collect{|el|el.to_i}
    
    rows.keep_if {|el| cids.include?(el.cid.to_i)}
        
    #filter 2 place_id
    c = "select profile_id, place_id from employments"
    pids = Employment.find_by_sql(c)
    pids.keep_if {|el| ids.include?(el.place_id.to_i)}
    pids = pids.collect(&:profile_id).collect{|el|el.to_i}
    rows.keep_if {|el| pids.include?(el.pid.to_i)} 
    rows.count
  end
    
end