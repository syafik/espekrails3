# -*- encoding : utf-8 -*-
InstunRails3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

    match '/timetables/timetable_for_user/:id' => 'timetables#timetable_for_user', :via => [:get]
  resources :timetables do 
    member do
      get 'list'
    end
  end

  resources :session_code do
    collection do
      get "new_popup"
      post "create_popup"
    end
  end
  resources :permission do
    collection do
      get 'list'
    end
  end
  resources :favourite_places do
    collection do
      get 'list'
    end
  end
  match '/user_applications/akuan_sah_hadir' => 'user_applications#akuan_sah_hadir', :via => [:get]
  match '/user_applications/exam_before/:id' => 'user_applications#exam_before', :via => [:get]
  match '/user_applications/exam_after/:id' => 'user_applications#exam_after', :via => [:get]
  match '/user_applications/tambah_update/:id' => 'user_applications#tambah_update', :via => [:post]
  match '/user_applications/tambah/:id' => 'user_applications#tambah', :via => [:post]
  match '/user_applications/show_attendance/:id' => 'user_applications#show_attendance', :via => [:get]
  resources :user_applications do
    collection do 
      get 'applied'
      get 'offered'
      get 'surat_tawaran'
      get 'attend'
      get 'history'
    end
  end
  resources :post_individus do
    collection do
      get 'list'
      get 'list_all'
    end
  end

  resources :post_courses do
    collection do
      get 'list'
      get 'list_all'
    end
  end

  resources :posts do
    collection do
      get 'list'
      get 'list_all'
    end
  end
  
  resources :job_profiles
  resources :religions
  resources :states
  resources :genders
  resources :races
  resources :marital_statuses
  resources :countries
  resources :relationships
  resources :cert_levels
  resources :titles
  resources :handicaps
  resources :permission
  resources :roles do
    collection do
      get 'list'
    end
  end
  resources :question_templates do
    collection do
      get 'list'
      post 'create_course'
      get 'new_course'
    end
  end
  resources :questions do
    collection do
      get 'list'
    end
  end
  resources :question_types do
    collection do
      get 'list'
    end
  end
  resources :question_sections do
    collection do
      get 'list'
    end
  end
  resources :scale_types do
    collection do
      get 'list'
    end
  end
  resources :scales do
    collection do
      get 'list'
    end
  end

  resources :hostel_statuses do
    collection do
      get 'list'
    end
  end
  resources :hostel_types do
    collection do
      get 'list'
    end
  end
  resources :hostel_policies do
    collection do
      get 'list'
    end
  end
  resources :hostel_fixtures do
    collection do
      get 'list'
    end
  end

  resources :facility_statuses do
    collection do
      get 'list'
    end
  end
  resources :facility_types do
    collection do
      get 'list'
    end
  end
  resources :facility_categories do
    collection do
      get 'list'
    end
  end
  
  resources :course_departments do
    collection do
      get 'list'
    end
  end
  resources :course_statuses do
    collection do
      get 'list'
    end
  end
  resources :course_fields do
    collection do
      get 'list'
      get 'new_popup'
      post 'create_popup'
    end
  end
  resources :course_locations do
    collection do 
      get 'new_popup'
      post 'create_popup'
    end
  end
  resources :methodologies do
    collection do 
      get 'list'
      get 'new_popup'
      post 'create_popup'
    end
  end

  resources :facilities do
    collection do
      get 'list'
      post 'createf'
    end
  end
  resources :facility_reservations do
    collection do
      get 'list'
    end
  end

  resources :places do
    collection do
      get 'list'
      get 'search'
      get 'list_kementerian'
      get 'list_pejabat'
      get 'new_kementerian'
      get 'new_pejabat'
      get 'create_kementerian'
      get 'create_pejabat'
    end
    member do
      get 'show_kementerian'
      get 'edit_kementerian'
      put 'update_kementerian'
      put 'update_pejabat'
      get 'show_pejabat'
      get 'edit_pejabat'
    end
  end

  resources :signatures do
    get 'new_popup'
    get 'edit_popup'
    put 'update_popup'
    collection do
      post 'create_popup'
      get 'list_popup'
      get 'new_popup'
    end
  end

  #match '/trainer/:course_implementation_id/edit_surat_lantik' => 'trainer#edit_surat_lantik', :via => [:post]
  match '/trainer/:course_implementation_id/edit_surat_lantik_all' => 'trainer#edit_surat_lantik_all', :via => [:get]
  match '/trainer/:course_implementation_id/edit_surat_lantik' => 'trainer#edit_surat_lantik', :via => [:post]
  match '/trainer/:course_implementation_id/cetak_surat_lantik_all' => 'trainer#cetak_surat_lantik_all', :via => [:post]
  match '/trainer/:course_implementation_id/cetak_surat_lantik_all' => 'trainer#cetak_surat_lantik_all', :via => [:put]
  match '/trainer/:course_implementation_id/cetak_surat_lantik' => 'trainer#cetak_surat_lantik', :via => [:post]
  match '/trainer/:course_implementation_id/cetak_surat_lantik' => 'trainer#cetak_surat_lantik', :via => [:put]
  resources :trainer do
    get 'collect'
    get 'release'
    post 'offer'
    get 'offer'
    get 'eval'
    get 'destroy'
    collection do
      get 'offer_all'
      get 'list'
      get 'search'
      post 'search_by_name'
      post 'search_by_ic'
      post 'search_by_phone'
      post 'search_by_expertise'
      post 'search_by_state'
      post 'offer'
    end
  end

  resources :staffs do
    collection do
      get 'list'
      get 'search'
      post 'search_by_name'
      post 'search_by_phone'
      post 'search_by_dept'
    end
  end
  
  resources :report do
    collection do
      get 'list'
      get 'kursus_online'
      get 'kursus_semasa'
      get 'ringkasan_ujian'
    end
  end

  resources :laporan do
    collection do
      get 'audit_trail'
      get 'penilaian_penyelarasan'
      get 'list_laporan'
      get 'pencapaian_ujian_bidang'
      get 'mohon_espek'
      get 'statistik_kursus_tarikh'
      get 'pencapaian_ujian'
      get 'penilaian_penceramah'
      get 'penilaian_kemudahan'
      get 'penilaian_isi_kandungan'
      get 'senarai_ulasan'
      get 'kutipan_yuran'
      get 'kutipan_yuran_bhg'
      post 'sp_create'
      put 'sp_update'
    end
    member do
      get 'status_perlaksanaan'
    end
  end
  
  resources :reservations do
    collection do
      get 'list'
      get 'listp'
    end
    member do
      get 'new_popup'
      get 'edit_sah'
      get 'show_popup'
      get 'trainer_book'
      post 'trainer_book_create'
      get 'show_trainer_book'
      get 'edit_sah'
      post 'update_sah'
      get 'detail'
    end
  end

  resources :notifications do
    collection do
      get 'list'
      get 'report'
      get 'senaraibilik'
      get 'jadual_bilik_kuliah'
      get 'listp'
      get 'urushubung'
      post 'create_security_contact'
    end
    member do
      get 'detail'
      delete 'delete_security_contact'
      put 'approve'
    end
  end
  match '/hostels/list_sudah_checkin/:id' => 'hostels#list_sudah_checkin', :via => [:get]
  match '/hostels/iwannachkin/:id' => 'hostels#iwannachkin', :via => [:get]
  match '/hostels/showchkin/:id' => 'hostels#showchkin', :via => [:get]
  match '/hostels/:id/change_room' => 'hostels#change_room', :via => [:get]
  resources :hostels do
    collection do
      get 'list'
      get 'new_penghuni'
      post 'create_penghuni'
      get 'chkin_by_course'
      get 'find_checkout'
      get 'list_tutup'
      get 'find_guest'
      get 'rekod_guna_bilik'
      get 'blank'
      get 'lihat'
      get 'find_to_checkin'
      get 'list_active_course'
      get 'find_guest_result'
    end
    member do
      get 'iwannarent'
      get 'iverent'
      get 'showrent'
      get 'showchkin'
      get 'change_room_rent'
      get 'course_sankasha_ichiran'
      get 'cetak_list_checkin'
      get 'course_trainer_list'
      get 'iwannachkin'
      post 'ivedonechkin'
      get 'cetak_list_trainer_checkin'
    end
  end
  resources :quizzes do
    collection do
      get 'list'
      post 'hozon'
    end
    member do
      get 'shiken_ichiran'
      get 'shinki'
      get 'copy_shiken_ichiran'
      put 'simpan_copy_shiken_ichiran'
    end
  end
  
  match '/course_management/override_kelayakan/:id' => 'course_management#override_kelayakan', :via => [:post]
  match '/course_management/cetak_tempahan_iso/:id' => 'course_management#cetak_tempahan_iso', :via => [:post]
  match '/course_management/hantar_tempahan/:id' => 'course_management#hantar_tempahan', :via => [:post]
  match '/course_management/maklumat_kehadiran/:id' => 'course_management#maklumat_kehadiran', :via => [:get]
  match '/course_management/set_paparan_sijil/:id' => 'course_management#set_paparan_sijil', :via => [:post]
  match '/course_management/edit_surat_pengesahan/:id' => 'course_management#edit_surat_pengesahan', :via => [:post]
  match '/course_management/edit_surat_takhadir/:id' => 'course_management#edit_surat_takhadir', :via => [:post]
  match '/course_management/rujukan_kami/:id' => 'course_management#rujukan_kami', :via => [:get]
  match '/course_management/edit_tempah_sijil' => 'course_management#edit_tempah_sijil', :via => [:post]
  match '/course_management/cetak_sijil' => 'course_management#cetak_sijil', :via => [:post]
  resources :course_management do
    get 'evaluation_done'
    collection do
      get 'select_course'
      get 'sijil_select_course'
      get 'evaluated_courses'
      get 'register'
      get 'ichiran'
      get 'yuran'
      get 'attendance'
      get 'certificate'
      get 'evaluation'
      get 'p_evaluation'
      get 'enroll_selected'
      get 'cetak_sijil'
      get 'surat_pengesahan'
      get 'surat_takhadir'
      post 'isi_markah'
    end
    member do
      put 'jana_surat_pengesahan_pdf'
      put 'jana_surat_takhadir_pdf'
      get 'update_polisi_sijil'
      get 'new_polisi_sijil'
      get 'enroll_selected'
      get 'evaluation_kelompok'
      get 'jana_kelayakan'
      get 'tempah_sijil'
      get 'tempah_sijil_iso'
      get 'new_tarikh_sesi'
      post 'new_sesi'
      post 'edit_sesi'
      get 'create_sesi'
      get 'update_sesi'
      get 'new_tarikh_sesi'
      get 'new_cetak_kehadiran'
      get 'new_catat_kehadiran'
      get 'kehadiran_manual'
      post 'masuk_data_kehadiran'
      get 'cetak_p_evaluation_iso'
      get 'cetak_p_evaluation'
      get 'list_signature'
    end
  end
  match '/course_applications/all/:id' => 'course_applications#all', :via => [:get]
  match '/course_applications/unprocessed/:id' => 'course_applications#unprocessed', :via => [:get]
  match '/course_applications/hadir/:id' => 'course_applications#hadir', :via => [:get]
  match '/course_applications/accepted/:id' => 'course_applications#accepted', :via => [:get]
  match '/course_applications/rejected/:id' => 'course_applications#rejected', :via => [:get]
  match '/course_applications/confirmed/:id' => 'course_applications#confirmed', :via => [:get]
  match '/course_applications/confirmednot/:id' => 'course_applications#confirmednot', :via => [:get]
  match '/course_applications/norespon/:id' => 'course_applications#norespon', :via => [:get]
  match '/course_applications/takhadir/:id' => 'course_applications#takhadir', :via => [:get]
  match '/course_applications/edit_surat_tawaran' => 'course_applications#edit_surat_tawaran', :via => [:get]
  match '/course_applications/sah_hadir_selected' => 'course_applications#sah_hadir_selected', :via => [:get]
  match '/course_applications/cetak_pemohon/:id' => 'course_applications#cetak_pemohon', :via => [:get]
  match '/course_applications/cetak_pemohon_semua/:id' => 'course_applications#cetak_pemohon_semua', :via => [:get]
  match '/course_applications/konaitokimeta' => 'course_applications#konaitokimeta', :via => [:get]
  match '/course_applications/new_for_logged_in_user/:id' => 'course_applications#new_for_logged_in_user', :via => [:get]
  match '/course_applications/create_for_logged_in_user/:id' => 'course_applications#create_for_logged_in_user', :via => [:post]
  match '/course_applications/create_but_peserta_already_exist' => 'course_applications#create_but_peserta_already_exist', :via => [:post]
  match '/course_applications/new_but_peserta_already_exist' => 'course_applications#new_but_peserta_already_exist', :via => [:get]
  match '/course_applications/user_daftar/:id' => 'course_applications#user_daftar', :via => [:get]
  
  resources :course_applications do
    get 'new'
    get 'all'
    get 'edit_surat_tawaran_select_peserta'
    collection do
      get 'applicant'
      get 'all'
      get 'select_course'
      get 'search'
      get 'search_applicant'
      get 'search_by_name'
      post 'search_by_ic'
      post 'search_by_phone'
      get 'edit_surat_tunda_select_peserta'
      get 'new_peserta'
      get 'edit_surat_tunda'
      get 'edit_surat_tawaran_select_peserta'
      get 'cetak_pemohon_semua'
      get 'grades_for_lookup'
      get 'reason_rejected'
      get 'accept_selected'
      post 'create_peserta'
      post 'cetak_surat_iklan'
      get 'new_popup'
    end
    member do
      post 'cetak_surat_tawaran'
      post 'cetak_surat_tunda'
      get 'copy_and_new'
      get 'edit_surat_tawaran'
      get 'unprocessed'
      get 'cetak_pemohon'
    end
  end
  
  match '/course_implementations/show_only_for_peserta/:id' => 'course_implementations#show_only_for_peserta', :via => [:get]

  resources :course_implementations do
    get 'show'
    get 'calendar'
    get 'edit_surat_iklan_select_pejabat'
    get 'edit_surat_iklan_la_apa_lagi'
    get 'rujukan_kami'
    collection do
      get 'list'
      get 'search'
      get 'search_for_user'
      get 'calendar'
      get 'edit_surat_iklan_select_kursus'
      get 'list_courses_from_today_to_future'
      get 'calendar_user'
      post 'copy_and_create'
      post 'cetak_surat_iklan'
      post 'search_for_user'
    end
    member do
      get 'add_course_trainer_refresh_opener'
      get 'add_course_trainer'
      get 'save_course_trainer_refresh_opener'
      get 'show_only_for_peserta'
      get 'copy_and_new'
      get 'save_course_trainer'
      get 'show_timetable2'
      get 'tambah_jadual'
      put 'simpan_tambah_jadual'
    end
  end
  resources :user do
    collection do
      get 'home'
      get 'login'
      get 'logout'
      get 'register'
      get 'forgot_password'
      post 'authenticate'
    end
  end
  
  resources :profiles do
    #    get 'show'
    get 'view'
    get 'addrole'
    get 'show_profile'
    put 'update_password'
    put 'update_password2'
    get 'edit_password'
    get 'edit_password2'
    get 'verify'
    get 'modrole'
    get 'destroy_peserta'
    get 'history'
    get 'setrole'
    put 'update_role'
    collection do
      get 'search_akaun'
      get 'list'
      get 'list_all'
      get 'list_notall'
      get 'view'
      get 'view_waris'
      get 'view_khidmat'
      get 'view_akademik'
      get 'view_kursus'
      get 'edit_peribadi'
      put 'update_peribadi'
    end
  end
  
  match '/hr/semak_by_ic' => 'hr#semak_by_ic', :via => [:post]
  match '/hr/search_by_ic' => 'hr#search_by_ic', :via => [:post]
  match '/hr/semak_by_name' => 'hr#semak_by_name', :via => [:post]
  match '/hr/course_record' => 'hr#course_record', :via => [:post]
  match '/hr/search_record' => 'hr#search_record', :via => [:post]
  match '/hr/select_course_select_peserta/:id' => 'hr#select_course_select_peserta', :via => [:get]
  match '/hr/select_course_mohon_kursus/:id' => 'hr#select_course_mohon_kursus', :via => [:get]
  match '/hr/apply_for_course' => 'hr#apply_for_course', :via => [:post]
  match '/hr/semak_status_mohon/:id' => 'hr#semak_status_mohon', :via => [:get]
  resources :hr do
    collection do
      get 'search_applicant'
      get 'list_courses_from_today_to_future'
      get 'select_course_batal'
      get 'search_applicant_status'
      get 'course_record'
      get 'select_quiz'
      get 'rekod_mohon_hadir'
    end
    member do
      get 'show_timetable2'
    end
  end
  resources :menu do
    collection do
      get 'admin'
      get 'sumber_manusia'
      get 'user'
      get 'penyelaras'
      get 'pendaftar'
      get 'domestik'
      get 'keselamatan'
      get 'pegawai_sijil'
      get 'rnd'
      get 'laporan'
    end
  end
  resources :main do
    collection do
      get 'home'
    end
  end
  
  match '/quiz_answers/show_answer3/:id' => 'hr#show_answer3', :via => [:get]
  resources :quiz_answers
  resources :quiz_questions do
    collection do
      post 'create_obj'
    end
    member do
      get 'list_soalan'
      get 'list_peserta'
      get 'cetak_soalan'
      get 'new_obj'
    end
  end

  resources :evaluations do
    get 'trainer_report'
    get 'facility_report'
    get 'management_report'
    get 'content_report'
    get 'comment_report'
    collection do
      get 'user_hyouka'
    end
  end
  match '/ajax/ajax_find_course_field' => 'ajax#ajax_find_course_field', :via => [:post]
  match '/ajax/ajax_find_coordinator' => 'ajax#ajax_find_coordinator', :via => [:post]
  match '/ajax/check_existence_of_course_implementation_code' => 'ajax#check_existence_of_course_implementation_code', :via => [:post]
  match '/ajax/auto_tarikh_tutup' => 'ajax#auto_tarikh_tutup', :via => [:post]
  match '/ajax/isvalid_date' => 'ajax#isvalid_date', :via => [:post]
  match '/ajax/find_course_by_code' => 'ajax#find_course_by_code', :via => [:post]
  match '/ajax/find_course_by_code_ca' => 'ajax#find_course_by_code_ca', :via => [:get]
  match '/ajax/find_course_by_code_2' => 'ajax#find_course_by_code_2', :via => [:get]
  match '/ajax/children_of_place' => 'ajax#children_of_place', :via => [:post]
  match '/ajax/grand_and_children_of_place' => 'ajax#grand_and_children_of_place', :via => [:post]
  match '/ajax/staff_find_jawatan' => 'ajax#staff_find_jawatan', :via => [:post]
  resources :ajax do
    collection do
      get 'ajax_nric'
      post 'facility_category_type'
    end
  end
  match '/register/to_enroll/:id' => 'register#to_enroll', :via => [:get]
  resources :register
  resources :permissions do
    collection do
      get 'list'
    end
  end
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'main#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
