class ReportTablesController < ApplicationController
  layout "standard-layout"
  before_filter :prepare_and_check_month_data, :except => [:application_and_attendance_query]

  def general_achievement
    if is_param_month_range_valid?
      filter_plan = "AND EXTRACT(month FROM date_plan_start) >= #{params[:month_from]} AND EXTRACT(month FROM date_plan_end) <= #{params[:month_until]} 
                 AND EXTRACT(year FROM date_plan_start) = #{params[:year]} AND EXTRACT(year FROM date_plan_end) = #{params[:year]} "
      filter_realization = "AND EXTRACT(month FROM date_start) >= #{params[:month_from]} AND EXTRACT(month FROM date_end) <= #{params[:month_until]} 
                          AND EXTRACT(year FROM date_start) = #{params[:year]} AND EXTRACT(year FROM date_end) = #{params[:year]} "
      filter_target = "AND EXTRACT(month FROM date_start) >= #{params[:month_from]} AND EXTRACT(month FROM date_end) <= #{params[:month_until]} 
                       AND EXTRACT(year FROM date_start) = #{params[:year]} AND EXTRACT(year FROM date_end) = #{params[:year]} "
      filter_presence = "AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} AND EXTRACT(year FROM date_apply) = #{params[:year]}"
                          
      condition_1 = "Select id from course_implementations where code LIKE 'T%' AND code NOT LIKE 'TM%'"
      condition_2 = "Select id from course_implementations where code LIKE 'U%'"
      condition_3 = "Select id from course_implementations where code LIKE 'TM%'"
      result_1 = general_achievement_query('Pentadbiran Tanah', condition_1, filter_plan, filter_realization, filter_target, filter_presence)
      result_2 = general_achievement_query('Ukur dan Pemetaan', condition_2, filter_plan, filter_realization, filter_target, filter_presence)
      result_3 = general_achievement_query('Teknologi Maklumat', condition_3, filter_plan, filter_realization, filter_target, filter_presence)

      @reports = result_1 + result_2 + result_3
    end  
  end

  
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

  def summary_group_ptg_ptd
    if is_param_month_range_valid?
      
      filter = " WHERE EXTRACT(month FROM date_apply) >= #{params[:month_from]}
                 AND EXTRACT(month FROM date_apply) <= #{params[:month_until]}
                 AND EXTRACT(year FROM date_apply) = #{params[:year]}"      

      valid_children_place_ids = []
      ptg_ptd_rows = Place.where("id =307 OR (name ilike '%galian%' OR name ilike '%tanah%' and name NOT ilike '%JABATAN KETUA PENGARAH TANAH DAN GALIAN (JKPTG)%') AND code NOT IN ('1010000006', '1011250000', '2037110000', '1365080000', '101125')")
      ptg_ptd_rows.each do |row|
        if row.id != 307
          valid_children_place_ids += row.children.collect(&:id)
        end
      end
      valid_place_ids = (ptg_ptd_rows.collect(&:id) + valid_children_place_ids) .uniq
      
      pids = ptg_ptd_filter(valid_place_ids, filter)
      pids = pids.collect(&:pid).collect{|el|el.to_i}
      
      group_query = "select count(ca.id) as subtotal, ((cast (count(ca.id) as float)) / #{pids.count})*100 as percentage, st.id, st.description as state_name
              from course_applications ca join profiles pf on ca.profile_id = pf.id
              join states st on pf.state_id = st.id
              AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
              AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
              AND EXTRACT(year FROM date_apply) = #{params[:year]}
              AND pf.id in (#{pids.split.join(',')})
              group by st.id, st.description
              order by (count(ca.id)) desc"
                            
      @reports =  CourseApplication.find_by_sql(group_query)      
    end
  end

  def summary_group_jkptg
    if is_param_month_range_valid?
      
      filter = " WHERE EXTRACT(month FROM date_apply) >= #{params[:month_from]}
                 AND EXTRACT(month FROM date_apply) <= #{params[:month_until]}
                 AND EXTRACT(year FROM date_apply) = #{params[:year]}"      

      valid_children_place_ids = []
      ptg_ptd_rows = Place.where("id =307 OR (name ilike '%JABATAN KETUA PENGARAH TANAH DAN GALIAN (JKPTG)%' OR name ilike '%galian%' OR name ilike '%tanah%') AND code NOT IN ('1010000006', '1011250000', '2037110000', '1365080000', '101125')")
      ptg_ptd_rows.each do |row|
        if row.id != 307
          valid_children_place_ids += row.children.collect(&:id)
        end
      end
      valid_place_ids = (ptg_ptd_rows.collect(&:id) + valid_children_place_ids) .uniq
      
      pids = ptg_ptd_filter(valid_place_ids, filter)
      pids = pids.collect(&:pid).collect{|el|el.to_i}
      
      group_query = "select count(ca.id) as subtotal, ((cast (count(ca.id) as float)) / #{pids.count})*100 as percentage, st.id, st.description as state_name
              from course_applications ca join profiles pf on ca.profile_id = pf.id
              join states st on pf.state_id = st.id
              AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
              AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
              AND EXTRACT(year FROM date_apply) = #{params[:year]}
              AND pf.id in (#{pids.split.join(',')})
              group by st.id, st.description
              order by (count(ca.id)) desc"
                            
      @reports =  CourseApplication.find_by_sql(group_query)      
    end
  end

  
  def summary_group_jupem
    if is_param_month_range_valid?
    
      filter = " WHERE EXTRACT(month FROM date_apply) >= #{params[:month_from]}
                 AND EXTRACT(month FROM date_apply) <= #{params[:month_until]}
                 AND EXTRACT(year FROM date_apply) = #{params[:year]}"      

      valid_children_place_ids = []
      ptg_ptd_rows = Place.where("UPPER(name) ilike '%JUPEM%'")
      ptg_ptd_rows.each do |row|
        if row.id != 307
          valid_children_place_ids += row.children.collect(&:id)
        end
      end
      valid_place_ids = (ptg_ptd_rows.collect(&:id) + valid_children_place_ids).uniq
      
      pids = ptg_ptd_filter(valid_place_ids, filter)
      pids = pids.collect(&:pid).collect{|el|el.to_i}
      
      group_query = "select count(ca.id) as subtotal, ((cast (count(ca.id) as float)) / #{pids.count})*100 as percentage, st.id, st.description as state_name
              from course_applications ca join profiles pf on ca.profile_id = pf.id
              join states st on pf.state_id = st.id
              AND EXTRACT(month FROM date_apply) >= #{params[:month_from]} 
              AND EXTRACT(month FROM date_apply) <= #{params[:month_until]} 
              AND EXTRACT(year FROM date_apply) = #{params[:year]}
              AND pf.id in (#{pids.split.join(',')})
              group by st.id, st.description
              order by (count(ca.id)) desc"
                            
      @reports =  CourseApplication.find_by_sql(group_query)      
              
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
    @planning_years = Trainer.find_by_sql("SELECT distinct extract(year from tt.date)as year FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id  AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id ORDER BY year DESC").collect(&:year)
    if is_param_month_range_valid?
      date_filter = "EXTRACT(month FROM tt.date) >= #{params[:month_from]} AND EXTRACT(month FROM tt.date) <= #{params[:month_until]} AND EXTRACT(year FROM tt.date) = #{params[:year]}"
      total = Trainer.find_by_sql("select count(*) as amount from (SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id 
        AND ci.id = tt.course_implementation_id AND #{date_filter} group by t.id) tt")[0].amount.to_i

      sql = []
      
      sql[0] = "SELECT 'Pengurusan dan Perundangan Tanah' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 1
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 1 AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      sql[1] = "SELECT 'Ukur dan Pemetaan' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 1
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 1 AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      sql[2] = "SELECT 'Teknologi Maklumat' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 1
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 1 AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      sql[3] = "SELECT 'Pentadbiran dan Kewangan' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 1
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 1 AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      sql[4] = "SELECT 'Luaran' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND (t.is_internal = 0 OR t.is_internal IS NULL)
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND (t.is_internal = 0 OR t.is_internal IS NULL) AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      sql[5] = "SELECT 'Dalaman tanpa bahagian' AS name, (select count(*) from (
        SELECT t.id trainer_id
        FROM trainers t, profiles p, course_implementations_trainers cit, course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND t.is_internal = 1 AND course_department_id is NULL
        AND cit.trainer_id = t.id AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id
        AND #{date_filter} group by t.id) tt) as amount,

        (cast ((select count(*) from (SELECT t.id trainer_id FROM trainers t, profiles p, course_implementations_trainers cit,
        course_implementations ci, timetables tt
        WHERE t.profile_id = p.id AND t.is_internal = 1 AND course_department_id is NULL AND cit.trainer_id = t.id
        AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
        group by t.id) tt) as float) / #{total}*100) as percentage"

      @reports = []
      sql.each do |i|
        @reports += Trainer.find_by_sql(i)
      end
    end
  end

  def teach_hour_by_department
    @planning_years = Trainer.find_by_sql("SELECT distinct extract(year from tt.date)as year FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id  AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id ORDER BY year DESC").collect(&:year)
    if is_param_month_range_valid?
      date_filter = "EXTRACT(month FROM tt.date) >= #{params[:month_from]} AND EXTRACT(month FROM tt.date) <= #{params[:month_until]} AND EXTRACT(year FROM tt.date) = #{params[:year]}"

      sql = []
      
      sql[0] = "SELECT 'Pengurusan dan Perundangan Tanah' AS name, (
      SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 1 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_dalaman,
      (SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 1 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_luaran"

      sql[1] = "SELECT 'Ukur dan Pemetaan' AS name, (
      SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 1 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_dalaman,
      (SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 2 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_luaran"

      sql[2] = "SELECT 'Teknologi Maklumat' AS name, (
      SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 1 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_dalaman,
      (SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 3 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_luaran"

      sql[3] = "SELECT 'Pentadbiran dan Kewangan' AS name, (
      SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 1 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_dalaman,
      (SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id = 9 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_luaran"

      sql[4] = "SELECT 'Tanpa Bahagian' AS name, (
      SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id is NULL AND t.is_internal = 1 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_dalaman,
      (SELECT sum(EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600) as hour FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id AND p.course_department_id is NULL AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount_luaran"

      @reports = []
      sql.each do |i|
        @reports += Trainer.find_by_sql(i)
      end
    end
  end

  def students_feedback
    
    sql_faedah = "select 'Mendapat Faedah Daripada Kursus' as name , (
    select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Apakah anda telah mendapat faedah dari kursus ini?'
    and answer = true) as ya,
    (select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Apakah anda telah mendapat faedah dari kursus ini?'
    and answer = false) as tidak"
    
    @report_faedah = EvaluationTruefalse.find_by_sql(sql_faedah)

    sql_memperaku = "select 'Memperaku kepada Rakan di Jabatan' as name, (
    select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Adakah anda ingin memperakukan kursus ini kepada orang lain'
    and answer = true) as ya,
    (select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Apakah anda telah mendapat faedah dari kursus ini?'
    and answer = false) as tidak"
    
    @report_memperaku = EvaluationTruefalse.find_by_sql(sql_memperaku)
    
    sql_kesesuaian = "select 'Kesesuaian Jangka Masa Kursus' as name , (
    select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Adakah jangkamasa kursus bersesuaian'
    and answer = true) as ya,
    (select count(answer)  
    from evaluation_questions eqs 
    join evaluation_truefalses etfs on etfs.evaluation_question_id = eqs.id
    where questiontext = 'Adakah jangkamasa kursus bersesuaian'
    and answer = false) as tidak"
    @report_kesesuaian = EvaluationTruefalse.find_by_sql(sql_kesesuaian)
    
  end

  def payment_by_department
    @planning_years = Trainer.find_by_sql("SELECT distinct extract(year from tt.date)as year FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt
      WHERE t.profile_id = p.id  AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id ORDER BY year DESC").collect(&:year)
    if is_param_month_range_valid?
      date_filter = "EXTRACT(month FROM tt.date) >= #{params[:month_from]} AND EXTRACT(month FROM tt.date) <= #{params[:month_until]} AND EXTRACT(year FROM tt.date) = #{params[:year]}"
      total = Trainer.find_by_sql("SELECT sum(cp.total_approved) as total FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      group by p.course_department_id, t.is_internal")[0].total.to_f
      sql = []

      sql[0] = "SELECT 'Pengurusan dan Perundangan Tanah' AS name, (
      SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =1 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount,
      ((cast ((SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =1 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as float) / #{total}*100)) as percentage"

      sql[1] = "SELECT 'Ukur dan Pemetaan' AS name, (
      SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =2 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount,
      ((cast ((SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =2 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as float) / #{total}*100)) as percentage"

      sql[2] = "SELECT 'Teknologi Maklumat' AS name, (
      SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =3 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount,
      ((cast ((SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =3 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as float) / #{total}*100)) as percentage"

      sql[3] = "SELECT 'Pentadbiran dan Kewangan' AS name, (
      SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =9 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount,
      ((cast ((SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id =9 AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as float) / #{total}*100)) as percentage"

      sql[4] = "SELECT 'Tanpa Bahagian' AS name, (
      SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id is NULL AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as amount,
      ((cast ((SELECT sum(cp.total_approved) FROM trainers t, profiles p,
      course_implementations_trainers cit, course_implementations ci, timetables tt, claim_payments cp
      WHERE t.profile_id = p.id AND p.course_department_id is NULL AND t.is_internal = 0 AND cit.trainer_id = t.id
      AND ci.id = cit.course_implementation_id AND ci.id = tt.course_implementation_id AND cp.timetable_id = tt.id
      AND #{date_filter}
      group by p.course_department_id, t.is_internal) as float) / #{total}*100)) as percentage"

      @reports = []
      sql.each do |i|
        @reports += Trainer.find_by_sql(i)
      end
    end
  end
  
  private

  def prepare_and_check_month_data
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from date_apply)as year from vw_detailed_applicants_all ORDER BY year DESC").collect(&:year)
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

  def general_achievement_query(title, condition, filter_plan, filter_realization, filter_target, filter_presence)
    sql = "select '#{title}' as name, 
    (select count(ci.id)
    from course_implementations ci
    where ci.id in (
      #{condition}
      #{filter_plan})) as plan,
      
      (select count(ci.id)
      from course_implementations ci
      where ci.id in (
        #{condition}
        #{filter_realization})) as realization,

      (select sum(ci.capacity)
      from course_implementations ci
      where ci.id in (
        #{condition}
        #{filter_plan})) as target,

      (select count(vdaa.profile_id)
        FROM vw_detailed_applicants_all vdaa
        WHERE vdaa.course_implementation_id IN (
        #{condition})
        AND student_status_id IN (5,8,9) #{filter_presence}) as apresence"

        return CourseApplication.find_by_sql(sql)
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
  
  def ptg_ptd_filter(ids, filter)
    a = "select course_implementation_id as cid, profile_id as pid FROM course_applications #{filter}"
    rows = CourseApplication.find_by_sql(a)
    
    #filter 1 course_implementation.id
    cids = CourseImplementation.all      
    cids = cids.collect(&:id).collect{|el|el.to_i}
    
    rows.keep_if {|el| cids.include?(el.cid.to_i)}
        
    #filter 2 place_id
    c = "select profile_id, place_id from employments"
    pids = Employment.find_by_sql(c)
    pids.keep_if {|el| ids.include?(el.place_id.to_i)}
    pids = pids.collect(&:profile_id).collect{|el|el.to_i}
    rows.keep_if {|el| pids.include?(el.pid.to_i)} 
    return rows
  end  

end