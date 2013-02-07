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
  resources :timetables do 
    member do
      get 'list'
    end
  end

  resources :session_code do
    
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
    end
  end

  resources :post_courses do
    collection do
      get 'list'
    end
  end

  resources :posts do
    collection do
      get 'list'
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
  resources :role
  
  resources :question_templates
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

  resources :hostel_statuses
  resources :hostel_types
  resources :hostel_policies
  resources :hostel_fixtures

  resources :facility_statuses
  resources :facility_types
  resources :facility_categories do
    collection do
      get 'list'
    end
  end
  
  resources :course_departments
  resources :course_statuses
  resources :course_fields do
    collection do
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

  match '/trainer/:course_implementation_id/edit_surat_lantik' => 'trainer#edit_surat_lantik', :via => [:post]
  match '/trainer/:course_implementation_id/edit_surat_lantik' => 'trainer#edit_surat_lantik', :via => [:post]
  resources :trainer do
    post 'offer'
    get 'offer'
    collection do
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
    end
    member do
      get 'iwannarent'
      get 'iverent'
      get 'showrent'
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
    end
  end
  resources :course_management do
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
    end
    member do
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
    end
  end
  resources :course_applications do
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
    end
    member do
      get 'all'
      get 'hadir'
      get 'unprocessed'
      get 'accepted'
      get 'rejected'
      get 'confirmed'
      get 'confirmednot'
      get 'takhadir'
      get 'edit_surat_tawaran'
      post 'cetak_surat_tawaran'
      post 'cetak_surat_tunda'
      get 'copy_and_new'
      get 'unprocessed'
    end
  end
  resources :course_implementations do
    collection do
      get 'list'
      get 'search'
      get 'search_for_user'
      get 'calendar'
      get 'edit_surat_iklan_select_kursus'
      get 'list_courses_from_today_to_future'
      get 'calendar_user'
      post 'copy_and_create'
    end
    member do
      get 'add_course_trainer_refresh_opener'
      get 'add_course_trainer'
      get 'save_course_trainer_refresh_opener'
      get 'show_only_for_peserta'
      get 'copy_and_new'
      get 'save_course_trainer'
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
    get 'destroy_peserta'
    get 'history'
    collection do
      get 'view'
      get 'view_waris'
      get 'view_khidmat'
      get 'view_akademik'
      get 'view_kursus'
      get 'edit_password'
      get 'edit_peribadi'
      put 'update_peribadi'
    end
  end
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
  resources :quiz_questions do
    member do
      get 'list_soalan'
      get 'list_peserta'
      get 'cetak_soalan'
    end
  end

  resources :evaluations do
    collection do
      get 'user_hyouka'
    end
  end
 
  resources :ajax do
    collection do
      #      post 'ajax_find_course_field '
      #      post 'ajax_find_coordinator'
      get 'ajax_nric'
      post 'facility_category_type'
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
