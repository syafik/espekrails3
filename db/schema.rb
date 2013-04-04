# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130326151829) do

  create_table "acct_statuses", :force => true do |t|
    t.string "description", :limit => 50
  end

  create_table "approvals", :force => true do |t|
    t.string "description", :limit => 30
  end

  create_table "attendance_sessions", :force => true do |t|
    t.string "description", :limit => 50
  end

  create_table "attendances", :force => true do |t|
    t.integer "course_application_id"
    t.date    "date_attend"
    t.integer "course_implementation_id"
    t.integer "sesi_harian_id"
    t.integer "session_code_id"
  end

  create_table "audit_trails", :force => true do |t|
    t.string   "action_type",     :limit => 200
    t.string   "modul",           :limit => 100
    t.string   "submodul",        :limit => 100
    t.string   "rail_controller", :limit => 100
    t.string   "rail_action",     :limit => 100
    t.date     "created_at"
    t.datetime "created_on"
    t.string   "login",           :limit => 80
    t.integer  "user_id"
    t.integer  "role_id"
    t.text     "url"
  end

  create_table "category_trainers", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "cert_levels", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "cert_policy", :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "kehadiran_minima"
    t.string  "wajib_yuran",              :limit => 1
  end

  create_table "cert_status", :id => false, :force => true do |t|
    t.integer "id",                         :null => false
    t.string  "description", :limit => 100
  end

  create_table "certificates", :force => true do |t|
    t.integer "is_print",                             :default => 0
    t.date    "date_print"
    t.date    "date_grad"
    t.integer "pattern_id"
    t.integer "cert_status_id",                       :default => 1
    t.string  "new_cert_no",           :limit => 20
    t.date    "created_on"
    t.date    "updated_on"
    t.integer "course_application_id"
    t.integer "is_post",                              :default => 0
    t.integer "cert_no"
    t.string  "sent_by",               :limit => nil
    t.string  "letter_refno",          :limit => nil
    t.date    "letter_date"
    t.string  "remark",                :limit => 200
    t.integer "is_qualified",                         :default => 0
  end

  create_table "claim_payments", :force => true do |t|
    t.integer "trainer_id",                                                                        :null => false
    t.integer "timetable_id",                                                                      :null => false
    t.decimal "total_claim",         :precision => 10, :scale => 2
    t.decimal "total_approved",      :precision => 10, :scale => 2
    t.string  "status",                                             :default => "sedang diproses"
    t.integer "category_trainer_id"
    t.decimal "total_time",          :precision => 10, :scale => 2
    t.date    "timetable_date"
  end

  create_table "contact_persons", :force => true do |t|
    t.integer "place_id"
    t.integer "profile_id"
  end

  create_table "countries", :force => true do |t|
    t.string "code",        :limit => 3
    t.string "description", :limit => 40
    t.string "extra",       :limit => 2
  end

  create_table "course_applications", :force => true do |t|
    t.integer "course_implementation_id",                                                             :null => false
    t.date    "date_apply"
    t.integer "approval_id",                                                           :default => 1
    t.date    "date_approval"
    t.integer "supervisor_profile_id"
    t.text    "reason"
    t.integer "profile_id",                                                                           :null => false
    t.integer "course_id"
    t.date    "created_at"
    t.date    "updated_at"
    t.time    "created_on"
    t.time    "updated_on"
    t.integer "student_status_id",                                                     :default => 1
    t.string  "supervisor_name",          :limit => 80
    t.string  "supervisor_jawatan",       :limit => 80
    t.integer "is_paid",                                                               :default => 0
    t.string  "supervisor_email",         :limit => 60
    t.string  "cfm_supervisor_name",      :limit => 200
    t.string  "cfm_supervisor_jawatan",   :limit => 200
    t.string  "cfm_supervisor_email",     :limit => 200
    t.date    "cfm_supervisor_date"
    t.date    "date_cfm_attend"
    t.date    "date_supervisor_cfm"
    t.string  "wakil_name",               :limit => 80
    t.string  "wakil_ic_number",          :limit => 12
    t.string  "wakil_jawatan",            :limit => 100
    t.integer "parent_id"
    t.integer "is_apply_online"
    t.integer "hostel_id"
    t.text    "cancel_reason"
    t.date    "cancel_date"
    t.string  "cancel_spv_name",          :limit => 200
    t.string  "cancel_spv_jawatan",       :limit => 200
    t.string  "cancel_spv_email",         :limit => 200
    t.string  "nama_pejabat",             :limit => 60
    t.string  "address1",                 :limit => 50
    t.string  "address2",                 :limit => 50
    t.string  "address3",                 :limit => 50
    t.decimal "fee_amount",                              :precision => 4, :scale => 2
    t.string  "receipt_no",               :limit => 30
    t.date    "payment_date"
    t.string  "layak_sijil",              :limit => 1
    t.string  "cert_remark",              :limit => 200
    t.decimal "markah_ujian_akhir"
    t.decimal "markah_penilaian_peserta"
    t.string  "ulasan_urusetia",          :limit => 200
    t.string  "no_sijil",                 :limit => 10
  end

  create_table "course_departments", :force => true do |t|
    t.string "code",        :limit => 5
    t.string "description", :limit => 250
  end

  create_table "course_evaluations", :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "profile_id"
    t.integer "question_id"
    t.integer "scale_id"
    t.text    "remarks"
    t.integer "course_application_id"
    t.integer "question_template_id"
  end

  create_table "course_fields", :force => true do |t|
    t.string  "code",                 :limit => 20
    t.string  "description",          :limit => 100, :null => false
    t.integer "course_department_id"
  end

  create_table "course_implementations", :force => true do |t|
    t.integer  "course_id"
    t.integer  "capacity",                                            :null => false
    t.date     "date_plan_start",                                     :null => false
    t.date     "date_plan_end",                                       :null => false
    t.date     "date_start"
    t.date     "date_end"
    t.date     "last_date"
    t.date     "check_date"
    t.time     "time_start"
    t.time     "time_end"
    t.date     "created_on"
    t.date     "updated_on"
    t.integer  "coordinator1"
    t.integer  "coordinator2"
    t.string   "code",                  :limit => 50
    t.date     "date_publish"
    t.date     "date_apply_start"
    t.date     "date_apply_end"
    t.date     "date_evaluation_start"
    t.date     "date_evaluation_end"
    t.date     "date_check"
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer  "online_apply",                         :default => 1
    t.integer  "ketua_program"
    t.integer  "pen_ketua_program"
    t.datetime "briefing"
    t.string   "created_by",            :limit => 80
    t.string   "file",                  :limit => 100
  end

  add_index "course_implementations", ["code"], :name => "course_implementations_code_key", :unique => true

  create_table "course_implementations_profiles", :id => false, :force => true do |t|
    t.integer "course_implementation_id",                :null => false
    t.integer "profile_id",                              :null => false
    t.string  "sort",                     :limit => 100
  end

  create_table "course_implementations_question_templates", :id => false, :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "question_template_id"
  end

  create_table "course_implementations_trainers", :id => false, :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "trainer_id"
    t.integer "category_trainer_id",      :default => 1
  end

  create_table "course_locations", :force => true do |t|
    t.string "code",        :limit => 20
    t.string "description", :limit => 250, :null => false
  end

  create_table "course_statuses", :force => true do |t|
    t.string "description", :limit => 50, :null => false
  end

  create_table "course_types", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "courses", :force => true do |t|
    t.string  "code",                 :limit => 50
    t.string  "name",                 :limit => 100,                                :null => false
    t.text    "description"
    t.integer "course_type_id"
    t.integer "course_field_id"
    t.integer "course_status_id"
    t.integer "course_location_id"
    t.integer "place_id"
    t.text    "target_group"
    t.decimal "fee",                                 :precision => 10, :scale => 2
    t.text    "objective"
    t.text    "content"
    t.date    "created_on"
    t.date    "updated_on"
    t.integer "course_department_id"
    t.text    "reference"
  end

  create_table "courses_methodologies", :id => false, :force => true do |t|
    t.integer "course_id",                     :null => false
    t.integer "methodology_id",                :null => false
    t.string  "name",           :limit => 250
  end

  create_table "courses_target_groups", :id => false, :force => true do |t|
    t.integer "course_id",                      :null => false
    t.integer "target_group_id",                :null => false
    t.string  "name",            :limit => 250
  end

  create_table "courses_trainers", :id => false, :force => true do |t|
    t.integer "course_id",  :null => false
    t.integer "trainer_id", :null => false
  end

  create_table "employments", :force => true do |t|
    t.string  "staf_id",         :limit => 10
    t.date    "employment_date"
    t.integer "place_id"
    t.integer "job_profile_id"
    t.integer "profile_id"
    t.string  "unit",            :limit => 100
    t.integer "is_current",                     :default => 1
  end

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version"
  end

  create_table "evaluation_answers", :id => false, :force => true do |t|
    t.integer "id",                                                      :null => false
    t.integer "profile_id"
    t.integer "course_application_id"
    t.integer "evaluation_question_id"
    t.integer "answer",                                 :default => 0
    t.text    "answer_comment",                         :default => ""
    t.date    "created_on"
    t.time    "created_at"
    t.string  "created_by",               :limit => 50
    t.integer "course_implementation_id"
    t.string  "kelompok",                 :limit => 1,  :default => "0"
  end

  add_index "evaluation_answers", ["course_application_id", "evaluation_question_id"], :name => "evaluation_answers_course_application_id_key", :unique => true
  add_index "evaluation_answers", ["profile_id", "evaluation_question_id"], :name => "evaluation_answers_profile_id_key", :unique => true

  create_table "evaluation_comments", :id => false, :force => true do |t|
    t.integer "id",                                                      :null => false
    t.integer "profile_id"
    t.integer "course_application_id"
    t.integer "course_implementation_id"
    t.text    "comment",                                :default => ""
    t.date    "created_on"
    t.time    "created_at"
    t.string  "created_by",               :limit => 50
    t.string  "kelompok",                 :limit => 1,  :default => "0"
  end

  create_table "evaluation_questions", :force => true do |t|
    t.integer "evaluation_section_id"
    t.integer "evaluation_subsection_id"
    t.text    "questiontext"
    t.integer "evaluation_id"
    t.integer "evaluation_type_id"
    t.string  "created_by",               :limit => 50
  end

  create_table "evaluation_rankings", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "evaluation_question_id"
    t.integer "max_ranking"
    t.string  "created_by",             :limit => 50
  end

  create_table "evaluation_sections", :force => true do |t|
    t.text "description"
  end

  create_table "evaluation_subsections", :id => false, :force => true do |t|
    t.integer "id",                    :null => false
    t.integer "evaluation_section_id"
    t.text    "description"
  end

  create_table "evaluation_trainer_rankings", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "timetable_id"
    t.integer "trainer_id"
    t.integer "evaluation_question_id"
    t.integer "max_ranking"
    t.string  "created_by",             :limit => 50
    t.integer "topic_id"
  end

  create_table "evaluation_truefalses", :id => false, :force => true do |t|
    t.integer "id",                                                     :null => false
    t.integer "evaluation_question_id"
    t.boolean "answer",                               :default => true
    t.text    "trueanswer"
    t.text    "falseanswer"
    t.string  "created_by",             :limit => 50
  end

  create_table "evaluation_types", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "evaluations", :force => true do |t|
    t.integer  "course_id"
    t.integer  "course_implementation_id"
    t.string   "name"
    t.text     "intro"
    t.string   "created_by",               :limit => 50
    t.datetime "created_on",                             :null => false
    t.datetime "updated_on",                             :null => false
  end

  create_table "expertises", :id => false, :force => true do |t|
    t.integer "id",                         :null => false
    t.string  "institution", :limit => 150
    t.integer "profile_id"
    t.string  "kepakaran",   :limit => 100
  end

  create_table "facilities", :force => true do |t|
    t.string  "code",                 :limit => 25
    t.string  "name",                 :limit => 100,                                :null => false
    t.integer "facility_category_id"
    t.integer "capacity"
    t.decimal "price",                               :precision => 10, :scale => 2
    t.text    "remark"
    t.date    "created_on"
    t.date    "updated_on"
    t.integer "facility_type_id"
    t.integer "facility_status_id"
  end

  create_table "facilities_timetables", :id => false, :force => true do |t|
    t.integer "timetable_id", :null => false
    t.integer "facility_id",  :null => false
  end

  create_table "facility_categories", :force => true do |t|
    t.string "code",        :limit => 25
    t.string "description", :limit => 100, :null => false
  end

  create_table "facility_purposes", :force => true do |t|
    t.string "description", :limit => 250, :null => false
  end

  create_table "facility_reservations", :force => true do |t|
    t.integer "facility_id",                                            :null => false
    t.integer "profile_id",                                             :null => false
    t.date    "date_from"
    t.date    "date_to"
    t.date    "created_on"
    t.integer "facility_purpose_id"
    t.integer "to_profile_id"
    t.integer "cc_profile_id"
    t.integer "course_implementation_id"
    t.string  "status",                   :limit => 1, :default => "0"
    t.integer "disahkan_oleh"
    t.date    "tarikh_sah"
  end

  create_table "facility_statuses", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "facility_types", :force => true do |t|
    t.string  "code",                 :limit => 25
    t.string  "description",          :limit => 100, :null => false
    t.integer "facility_category_id"
  end

  add_index "facility_types", ["code"], :name => "facility_types_code_key", :unique => true

  create_table "favourite_places", :id => false, :force => true do |t|
    t.integer "course_department_id"
    t.integer "place_id"
  end

  create_table "fixture_n_fittings", :id => false, :force => true do |t|
    t.integer "hostel_id",                                       :null => false
    t.integer "hostel_fixture_id",                               :null => false
    t.integer "quantity",                         :default => 1
    t.string  "remark",            :limit => 100
  end

  create_table "genders", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 10
  end

  create_table "handicaps", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "hostel_blocks", :force => true do |t|
    t.string  "code",        :limit => 25
    t.string  "description", :limit => 100, :null => false
    t.integer "gender"
  end

  create_table "hostel_facilities", :force => true do |t|
    t.integer "hostel_facility_type_id",                                               :null => false
    t.string  "code",                    :limit => 50
    t.string  "description",             :limit => 250,                                :null => false
    t.integer "capacity"
    t.decimal "price",                                  :precision => 10, :scale => 2
    t.integer "facility_status_id"
  end

  create_table "hostel_facility_types", :force => true do |t|
    t.string "code",        :limit => 50
    t.string "description", :limit => 250, :null => false
  end

  create_table "hostel_fixtures", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "hostel_histories", :force => true do |t|
    t.integer "profile_id", :null => false
    t.integer "hostel_id",  :null => false
    t.date    "created_on"
    t.text    "remark"
  end

  create_table "hostel_penghuni", :id => false, :force => true do |t|
    t.integer  "hostel_id"
    t.integer  "profile_id"
    t.string   "no_tel",                   :limit => 15
    t.string   "no_kenderaan",             :limit => 15
    t.string   "no_kunci",                 :limit => 15
    t.integer  "category",                               :default => 1
    t.integer  "course_implementation_id"
    t.date     "expected_date_out"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hostel_penghuni", ["profile_id"], :name => "hostel_penghuni_profile_id_key", :unique => true

  create_table "hostel_policies", :force => true do |t|
    t.integer "policy_item_id"
    t.string  "description",    :limit => 250
    t.string  "description2",   :limit => 250
  end

  add_index "hostel_policies", ["policy_item_id"], :name => "hostel_policies_policy_item_id_key", :unique => true

  create_table "hostel_profiles", :force => true do |t|
    t.integer "profile_id",                                              :null => false
    t.integer "hostel_id",                                               :null => false
    t.date    "created_on"
    t.date    "updated_on"
    t.integer "hostel_reservation_id"
    t.text    "remark"
    t.date    "expected_date_out"
    t.integer "is_key_returned"
    t.date    "date_in"
    t.date    "date_out"
    t.string  "no_tel",                   :limit => 15
    t.string  "no_kenderaan",             :limit => 15
    t.string  "no_kunci",                 :limit => 15
    t.string  "isroomok_after_out",       :limit => 1,  :default => "1"
    t.integer "category"
    t.integer "course_implementation_id"
  end

  create_table "hostel_reservations", :force => true do |t|
    t.integer "profile_id",                  :null => false
    t.integer "gender_id"
    t.integer "hostel_type_id",              :null => false
    t.integer "total_room",                  :null => false
    t.string  "confirm",        :limit => 1
    t.text    "remark"
    t.date    "created_on"
    t.date    "updated_on"
    t.date    "chkin_date"
    t.date    "chkout_date"
  end

  create_table "hostel_statuses", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "hostel_types", :force => true do |t|
    t.string "code",        :limit => 10
    t.string "description", :limit => 100
  end

  create_table "hostels", :force => true do |t|
    t.integer "block_id"
    t.integer "level"
    t.integer "room"
    t.integer "hostel_status_id"
    t.integer "hostel_type_id"
    t.decimal "rate",                            :precision => 10, :scale => 2
    t.string  "description",      :limit => 100
    t.integer "gender_id"
    t.decimal "rate2",                           :precision => 10, :scale => 2
    t.integer "capacity"
    t.integer "is_executive",                                                   :default => 0
    t.string  "room_name",        :limit => 20
    t.string  "room_no",          :limit => 4
    t.date    "tarikh_ditutup"
    t.text    "sebab_tutup"
  end

  create_table "job_profiles", :force => true do |t|
    t.string  "code",        :limit => 15
    t.string  "job_grade",   :limit => 10
    t.integer "ranking"
    t.text    "description"
    t.string  "job_name",    :limit => 100
  end

  create_table "latest_appoint_references", :id => false, :force => true do |t|
    t.integer "course_department_id"
    t.string  "latest_ref_no",        :limit => 50
    t.integer "id",                                 :null => false
  end

  create_table "latest_approve_references", :id => false, :force => true do |t|
    t.integer "course_department_id"
    t.string  "latest_ref_no",        :limit => 50
    t.integer "id",                                 :null => false
  end

  create_table "latest_letter_references", :id => false, :force => true do |t|
    t.integer "id",                                 :null => false
    t.integer "course_department_id"
    t.string  "latest_ref_no",        :limit => 50
  end

  create_table "latest_offer_references", :id => false, :force => true do |t|
    t.integer "course_department_id"
    t.string  "latest_ref_no",        :limit => 50
    t.integer "id",                                 :null => false
  end

  create_table "logos", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "name",         :limit => 50
    t.string  "content_type", :limit => 100
    t.string  "description",  :limit => 100
    t.binary  "data"
  end

  create_table "majors", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "marital_statuses", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 30
  end

  create_table "methodologies", :force => true do |t|
    t.string "description", :limit => 250, :null => false
  end

  create_table "nationality_statuses", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 30
  end

  create_table "notifications", :id => false, :force => true do |t|
    t.integer  "id",                                                     :null => false
    t.integer  "course_implementation_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "course_location_id"
    t.integer  "trainer_total"
    t.integer  "male_total"
    t.integer  "female_total"
    t.integer  "vip_total",                             :default => 0
    t.integer  "urusetia_total",                        :default => 2
    t.date     "date_plan_start"
    t.date     "date_plan_end"
    t.date     "approved_on"
    t.text     "remark"
    t.string   "status",                   :limit => 1, :default => "0"
    t.integer  "facility_id"
  end

  create_table "participant_evaluations", :id => false, :force => true do |t|
    t.integer "id",                                     :null => false
    t.integer "course_implementation_id"
    t.integer "best_student_id"
    t.string  "best_student",             :limit => 80
    t.text    "ulasan_keseluruhan"
  end

  create_table "patterns", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.date    "created_date"
    t.integer "logo_id"
    t.string  "name",         :limit => 100
  end

  create_table "permissions", :force => true do |t|
    t.string  "controller",                :default => "", :null => false
    t.string  "action",                    :default => "", :null => false
    t.string  "description"
    t.string  "modul",       :limit => 50
    t.string  "submodul",    :limit => 50
    t.string  "action_type", :limit => 1
    t.integer "auditable"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id", :default => 0, :null => false
    t.integer "role_id",       :default => 0, :null => false
  end

  create_table "place_contacts", :id => false, :force => true do |t|
    t.integer "id",                        :null => false
    t.integer "place_id"
    t.string  "name",       :limit => 100
    t.string  "position",   :limit => 60
    t.string  "phone",      :limit => 12
    t.string  "fax",        :limit => 12
    t.string  "email",      :limit => 60
    t.date    "updated_on"
    t.date    "created_on"
  end

  create_table "place_types", :force => true do |t|
    t.string "description", :limit => 60
  end

  create_table "places", :force => true do |t|
    t.string  "postcode",        :limit => 5
    t.string  "city",            :limit => 30
    t.integer "state_id"
    t.integer "country_id"
    t.string  "phone",           :limit => 12
    t.string  "fax",             :limit => 12
    t.integer "place_type_id"
    t.text    "description"
    t.integer "head_profile_id"
    t.integer "parent_id"
    t.string  "address1",        :limit => 45
    t.string  "address2",        :limit => 45
    t.string  "address3",        :limit => 45
    t.string  "address4",        :limit => 45
    t.string  "head_title",      :limit => 40
    t.string  "name",            :limit => 150
    t.string  "code"
  end

  create_table "policy_items", :force => true do |t|
    t.string "code",        :limit => 100, :null => false
    t.text   "description"
  end

  create_table "post_courses", :force => true do |t|
    t.string   "title"
    t.text     "post"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "profile_id"
    t.integer  "course_implementation_id"
    t.datetime "timeopen"
    t.datetime "timeclose"
  end

  create_table "post_individus", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "post"
    t.integer  "profile_id"
    t.integer  "user_id"
    t.datetime "timeopen"
    t.datetime "timeclose"
  end

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "post"
    t.integer  "profile_id"
    t.datetime "timeopen"
    t.datetime "timeclose"
  end

  create_table "prerequisites", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "prerequisite_course_id"
  end

  create_table "profile_statuses", :force => true do |t|
    t.string "description", :limit => 30
  end

  create_table "profiles", :force => true do |t|
    t.string  "name",                     :limit => 80
    t.string  "ic_number",                :limit => 12
    t.string  "old_ic_number",            :limit => 8
    t.string  "police_ic_number",         :limit => 8
    t.string  "army_ic_number",           :limit => 8
    t.string  "birth_certificate_number", :limit => 15
    t.date    "date_of_birth"
    t.string  "place_of_birth",           :limit => 30
    t.string  "passport_number",          :limit => 10
    t.integer "gender_id"
    t.integer "race_id"
    t.integer "religion_id"
    t.integer "nationality_status_id"
    t.integer "nationality_id"
    t.integer "marital_status_id"
    t.string  "road_place",               :limit => 30
    t.string  "postcode_area",            :limit => 30
    t.string  "postcode",                 :limit => 5
    t.string  "city",                     :limit => 30
    t.integer "state_id"
    t.integer "country_id"
    t.string  "phone",                    :limit => 12
    t.string  "mobile",                   :limit => 12
    t.string  "fax",                      :limit => 12
    t.string  "email",                    :limit => 60
    t.integer "title_id"
    t.integer "place_id"
    t.string  "designation",              :limit => 50
    t.string  "address1",                 :limit => 50
    t.string  "address2",                 :limit => 50
    t.string  "address3",                 :limit => 50
    t.integer "handicap_id",                            :default => 1
    t.integer "is_vegetarian",                          :default => 0
    t.string  "office_phone",             :limit => 12
    t.string  "codename",                 :limit => 10
    t.string  "salary_number",            :limit => 15
    t.string  "bank_account_number",      :limit => 15
    t.string  "bank_account_name",        :limit => 50
    t.integer "course_department_id"
    t.string  "hod",                      :limit => 80
    t.string  "opis",                     :limit => 60
    t.string  "image",                    :limit => 45
  end

  add_index "profiles", ["codename"], :name => "profiles_codename_key", :unique => true
  add_index "profiles", ["ic_number"], :name => "ic_is_unic", :unique => true

  create_table "profiles_timetables", :id => false, :force => true do |t|
    t.integer "profile_id",   :null => false
    t.integer "timetable_id", :null => false
  end

  create_table "profileskama", :id => false, :force => true do |t|
    t.integer "id",                                                    :null => false
    t.string  "name",                     :limit => 80
    t.string  "ic_number",                :limit => 12
    t.string  "old_ic_number",            :limit => 8
    t.string  "police_ic_number",         :limit => 8
    t.string  "army_ic_number",           :limit => 8
    t.string  "birth_certificate_number", :limit => 15
    t.date    "date_of_birth"
    t.string  "place_of_birth",           :limit => 30
    t.string  "passport_number",          :limit => 10
    t.integer "gender_id"
    t.integer "race_id"
    t.integer "religion_id"
    t.integer "nationality_status_id"
    t.integer "nationality_id"
    t.integer "marital_status_id"
    t.string  "road_place",               :limit => 30
    t.string  "postcode_area",            :limit => 30
    t.string  "postcode",                 :limit => 5
    t.string  "city",                     :limit => 30
    t.integer "state_id"
    t.integer "country_id"
    t.string  "phone",                    :limit => 12
    t.string  "mobile",                   :limit => 12
    t.string  "fax",                      :limit => 12
    t.string  "email",                    :limit => 60
    t.integer "title_id"
    t.integer "place_id"
    t.string  "designation",              :limit => 50
    t.string  "address1",                 :limit => 45
    t.string  "address2",                 :limit => 45
    t.string  "address3",                 :limit => 45
    t.integer "handicap_id",                            :default => 1
    t.integer "is_vegetarian",                          :default => 0
    t.string  "office_phone",             :limit => 12
    t.string  "codename",                 :limit => 10
    t.string  "salary_number",            :limit => 15
    t.string  "bank_account_number",      :limit => 15
    t.string  "bank_account_name",        :limit => 50
    t.integer "course_department_id"
    t.string  "hod",                      :limit => 80
    t.string  "opis",                     :limit => 60
  end

  create_table "qualifications", :force => true do |t|
    t.string  "institution",   :limit => 100
    t.integer "country_id"
    t.integer "cert_level_id"
    t.string  "year_start",    :limit => 4
    t.string  "year_end",      :limit => 4
    t.integer "major_id"
    t.string  "result",        :limit => 10
    t.integer "profile_id"
    t.string  "pengkhususan",  :limit => 100
  end

  create_table "question_sections", :force => true do |t|
    t.string  "description",          :limit => 100
    t.integer "question_type_id"
    t.integer "question_template_id"
  end

  create_table "question_templates", :force => true do |t|
    t.string "description"
  end

  create_table "question_types", :force => true do |t|
    t.string  "description",          :limit => 100
    t.integer "question_template_id"
  end

  create_table "questions", :force => true do |t|
    t.text    "description"
    t.integer "question_section_id"
    t.integer "question_template_id"
  end

  create_table "questions_scale_types", :id => false, :force => true do |t|
    t.integer "question_id",   :default => 0, :null => false
    t.integer "scale_type_id", :default => 0, :null => false
  end

  create_table "quiz_answers", :force => true do |t|
    t.integer "quiz_question_id"
    t.string  "fraction",                 :limit => 10
    t.integer "profile_id"
    t.integer "feedback"
    t.integer "course_application_id"
    t.integer "course_implementation_id"
    t.integer "quiz_id"
    t.integer "answer"
    t.text    "answer_subjective"
    t.boolean "answer_truefalse"
    t.integer "markah",                                 :default => 0
  end

  create_table "quiz_objectives", :force => true do |t|
    t.integer "quiz_question_id"
    t.string  "answer",           :limit => 510
    t.integer "answer_type_id"
  end

  create_table "quiz_questions", :force => true do |t|
    t.integer  "category"
    t.text     "questiontext"
    t.integer  "version"
    t.integer  "quiz_id"
    t.integer  "quiz_type_id"
    t.string   "file",                 :limit => 45
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "markah"
  end

  create_table "quiz_subjectives", :force => true do |t|
    t.integer "quiz_question_id"
    t.text    "answer"
  end

  create_table "quiz_truefalses", :force => true do |t|
    t.integer "quiz_question_id"
    t.boolean "answer",           :default => true
    t.text    "trueanswer"
    t.text    "falseanswer"
  end

  create_table "quiz_types", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "quizzes", :force => true do |t|
    t.integer  "course_id"
    t.string   "name",                     :default => ""
    t.text     "intro",                    :default => ""
    t.integer  "shufflequestions",         :default => 0
    t.integer  "shuffleanswers",           :default => 0
    t.datetime "created_on",                               :null => false
    t.datetime "updated_on",                               :null => false
    t.datetime "timeopen",                                 :null => false
    t.datetime "timeclose",                                :null => false
    t.integer  "course_implementation_id"
    t.integer  "course_department_id"
    t.integer  "timelimit"
    t.integer  "quiz_type_id"
  end

  create_table "races", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 30
  end

  create_table "relationships", :force => true do |t|
    t.string "description", :limit => 50
  end

  create_table "relatives", :force => true do |t|
    t.string  "name",            :limit => 80
    t.string  "postcode",        :limit => 5
    t.string  "city",            :limit => 30
    t.integer "state_id"
    t.integer "country_id"
    t.string  "phone",           :limit => 12
    t.string  "mobile",          :limit => 12
    t.integer "relationship_id"
    t.integer "profile_id"
    t.string  "address1",        :limit => 45
    t.string  "address2",        :limit => 45
    t.string  "address3",        :limit => 45
  end

  create_table "religions", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 15
  end

  create_table "reservation_trainers", :force => true do |t|
    t.integer  "course_implementation_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "staff_id"
    t.integer  "trainer_id"
    t.datetime "trainer_checkin"
    t.datetime "trainer_checkout"
    t.integer  "disahkan_oleh"
    t.date     "tarikh_sah"
    t.string   "disahkan_oleh_user",       :limit => 80
    t.string   "status",                   :limit => 1,  :default => "0"
  end

  create_table "reservations", :force => true do |t|
    t.integer  "course_implementation_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "course_id"
    t.integer  "trainer_total"
    t.integer  "male_total"
    t.integer  "female_total"
    t.integer  "vip_total",                              :default => 0
    t.integer  "urusetia_total",                         :default => 2
    t.date     "date_plan_start"
    t.date     "date_plan_end"
    t.integer  "staff_id"
    t.string   "status",                   :limit => 1,  :default => "0"
    t.integer  "disahkan_oleh"
    t.date     "tarikh_sah"
    t.string   "disahkan_oleh_user",       :limit => 80
    t.integer  "to_staff_id"
    t.integer  "cc_staff_id"
  end

  create_table "roles", :force => true do |t|
    t.string  "name",        :default => "", :null => false
    t.string  "description"
    t.boolean "omnipotent",                  :null => false
    t.boolean "system_role",                 :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "scale_types", :force => true do |t|
    t.string "description", :limit => 100, :null => false
  end

  create_table "scales", :force => true do |t|
    t.string  "description",   :limit => 100
    t.integer "rating"
    t.integer "point"
    t.integer "scale_type_id"
  end

  create_table "security_contacts", :id => false, :force => true do |t|
    t.integer "id",                       :null => false
    t.string  "name"
    t.string  "telephone"
    t.string  "email"
    t.string  "extension", :limit => nil
  end

  create_table "sesi_harian", :force => true do |t|
    t.integer "course_implementation_id"
    t.date    "tarikh"
    t.integer "session_code_id"
    t.string  "is_counted",               :limit => 1, :default => "1"
  end

  add_index "sesi_harian", ["course_implementation_id", "tarikh", "session_code_id"], :name => "sesi_harian_course_implementation_id_key", :unique => true

  create_table "sesi_makanan", :force => true do |t|
    t.integer "course_implementation_id"
    t.date    "tarikh"
    t.string  "breakfast",                :limit => 1
    t.string  "morning_tea",              :limit => 1
    t.string  "lunch",                    :limit => 1
    t.string  "evening_tea",              :limit => 1
    t.string  "dinner",                   :limit => 1
  end

  add_index "sesi_makanan", ["course_implementation_id", "tarikh"], :name => "sesi_makanan_course_implementation_id_key", :unique => true

  create_table "session_codes", :force => true do |t|
    t.string  "description",  :limit => 100
    t.string  "time_in_text", :limit => 50
    t.time    "time_start"
    t.time    "time_end"
    t.integer "susunan"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "signatures", :id => false, :force => true do |t|
    t.integer "id",                             :null => false
    t.string  "filename",        :limit => 100
    t.string  "person_name",     :limit => 100
    t.string  "person_position", :limit => 100
    t.string  "description",     :limit => 100
  end

  create_table "staffs", :force => true do |t|
    t.integer "course_department_id"
    t.integer "is_coordinator"
    t.integer "profile_id",                                         :null => false
    t.string  "status",               :limit => 1, :default => "1"
  end

  create_table "states", :force => true do |t|
    t.string "description", :limit => 40
    t.string "code",        :limit => 2
  end

  create_table "status_perlaksanaan", :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "position"
    t.string  "status",                   :limit => 20
    t.text    "catatan"
  end

  create_table "student_statuses", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "surat_iklan_content", :id => false, :force => true do |t|
    t.integer "id",                                      :null => false
    t.integer "user_id"
    t.integer "course_department_id"
    t.string  "ref_no",                   :limit => 50
    t.date    "letter_date"
    t.text    "perkara"
    t.string  "tempoh",                   :limit => 200
    t.string  "tandatangan_nama",         :limit => 200
    t.string  "tandatangan_jawatan",      :limit => 200
    t.integer "is_cetakan_komputer"
    t.integer "format_surat"
    t.integer "course_implementation_id"
    t.text    "perenggan4"
    t.text    "perenggan5"
    t.text    "perenggan3"
    t.text    "perenggan2"
    t.text    "perenggan1"
  end

  create_table "surat_lantik_content", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "course_department_id"
    t.string  "ref_no",                   :limit => 50
    t.date    "letter_date"
    t.text    "perkara"
    t.string  "tempoh",                   :limit => 200
    t.string  "tandatangan_nama",         :limit => 200
    t.string  "tandatangan_jawatan",      :limit => 200
    t.integer "is_cetakan_komputer"
    t.integer "format_surat"
    t.integer "course_implementation_id"
    t.text    "perenggan4"
    t.text    "perenggan5"
    t.text    "perenggan3"
    t.text    "perenggan2"
    t.text    "perenggan1"
    t.integer "id",                                      :null => false
  end

  create_table "surat_sah_content", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "course_department_id"
    t.string  "ref_no",                   :limit => 50
    t.date    "letter_date"
    t.text    "perkara"
    t.string  "tempoh",                   :limit => 200
    t.string  "tandatangan_nama",         :limit => 200
    t.string  "tandatangan_jawatan",      :limit => 200
    t.integer "is_cetakan_komputer"
    t.integer "format_surat"
    t.integer "course_implementation_id"
    t.text    "perenggan4"
    t.text    "perenggan5"
    t.text    "perenggan3"
    t.text    "perenggan2"
    t.text    "perenggan1"
    t.integer "id",                                      :null => false
  end

  create_table "surat_tawaran_content", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "course_department_id"
    t.string  "ref_no",                   :limit => 50
    t.date    "letter_date"
    t.text    "perkara"
    t.string  "tempoh",                   :limit => 200
    t.string  "tandatangan_nama",         :limit => 200
    t.string  "tandatangan_jawatan",      :limit => 200
    t.integer "is_cetakan_komputer"
    t.integer "format_surat"
    t.integer "course_implementation_id"
    t.text    "perenggan4"
    t.integer "id",                                      :null => false
    t.text    "perenggan5"
    t.text    "perenggan3"
    t.text    "perenggan2"
    t.text    "perenggan1"
  end

  create_table "target_groups", :force => true do |t|
    t.string "description", :limit => 250
  end

  create_table "tempahan_sijil", :force => true do |t|
    t.integer "course_implementation_id"
    t.string  "penerima",                 :limit => 200
    t.string  "anjuran",                  :limit => 200
    t.string  "tempat",                   :limit => 200
    t.string  "bahagian",                 :limit => 5
    t.date    "tarikh"
    t.string  "kategori_sijil",           :limit => 1
    t.text    "log_hantaran"
    t.string  "status",                   :limit => 1,   :default => "0"
    t.integer "disahkan_oleh"
    t.date    "tarikh_sah"
    t.string  "disahkan_oleh_user",       :limit => 80
  end

  create_table "timetables", :force => true do |t|
    t.integer "course_implementation_id"
    t.date    "date"
    t.string  "topic",                    :limit => 250
    t.text    "description"
    t.time    "time_start"
    t.time    "time_end"
  end

  create_table "timetables_trainers", :id => false, :force => true do |t|
    t.integer "trainer_id",   :null => false
    t.integer "timetable_id", :null => false
  end

  create_table "titles", :force => true do |t|
    t.string "description", :limit => 30
  end

  create_table "topics", :force => true do |t|
    t.integer  "course_implementation_id"
    t.integer  "trainer_id"
    t.string   "title",                    :limit => 200
    t.text     "description"
    t.datetime "shown_at"
  end

  create_table "trainer_contents", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "trainer_evaluations", :force => true do |t|
    t.integer "course_implementation_id"
    t.integer "profile_id"
    t.integer "trainer_profile_id"
    t.integer "trainer_content_id"
    t.integer "scale_id"
    t.text    "remarks"
  end

  create_table "trainers", :force => true do |t|
    t.decimal "rate",             :precision => 10, :scale => 2
    t.integer "is_internal"
    t.integer "profile_id",                                      :null => false
    t.decimal "fasilitator_rate", :precision => 10, :scale => 2
  end

  create_table "trainings", :force => true do |t|
    t.integer "course_implementation_id"
    t.text    "remarks"
    t.integer "profile_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 80, :default => ""
    t.string   "salted_password", :limit => 40, :default => ""
    t.string   "email",           :limit => 60
    t.string   "firstname",       :limit => 40
    t.string   "lastname",        :limit => 40
    t.string   "salt",            :limit => 40, :default => ""
    t.integer  "verified",                      :default => 0
    t.string   "role",            :limit => 40
    t.string   "security_token",  :limit => 40
    t.datetime "token_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "logged_in_at"
    t.integer  "deleted",                       :default => 0
    t.datetime "delete_after"
    t.integer  "profile_id"
    t.string   "phone",           :limit => 12
    t.string   "department",      :limit => 60
    t.string   "ic_number",       :limit => 12
    t.string   "name",            :limit => 80
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id", :default => 0, :null => false
    t.integer "role_id", :default => 0, :null => false
  end

  create_table "wireless", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "token",      :limit => 20
    t.string   "ic_number",  :limit => 12
    t.datetime "created_at"
  end

  add_index "wireless", ["token"], :name => "wireless_token_key", :unique => true

end
