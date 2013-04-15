# -*- encoding : utf-8 -*-
class CourseImplementation < ActiveRecord::Base
  belongs_to :course
  has_many :training
  has_many :course_applications
  has_many :vw_detailed_applicants
  has_many :quizzes
  has_many :evaluations
  has_many :evaluation_comments
  has_many :topics
  has_many :evaluation_answers
	has_many :sesi_harian
	has_many :sesi_makanan
	has_many :notifications
	has_many :reservations
	has_many :reservation_trainers
	has_many :facility_reservations

	has_one :cert_policy,
    :class_name => "CertPolicy"
	has_one :tempahan_sijil,
    :class_name => "TempahanSijil"
	
	has_one :surat_iklan_content,
    :class_name => "SuratIklanContent"

	has_one :surat_tawaran_content
	has_one :surat_sah_content
				
	has_many :timetables, :order => "date,time_start"
	
	belongs_to :penyelaras1,
    :class_name   => "Staff",
    :foreign_key  => "coordinator1"
	belongs_to :penyelaras2,
    :class_name   => "Staff",
    :foreign_key  => "coordinator2"
	belongs_to :k_program,
    :class_name   => "Staff",
    :foreign_key  => "ketua_program"
	belongs_to :pen_k_program,
    :class_name   => "Staff",
    :foreign_key  => "pen_ketua_program"

  has_and_belongs_to_many :question_templates
	has_and_belongs_to_many :profiles
	has_and_belongs_to_many :trainers
#	file_column :file, :store_dir => "/aplikasi/www/instun/public/course_implementation/file"
	#has_and_belongs_to_many :target_groups
    
	validates_presence_of :code ,
    :message    => ": masukkan kod kursus."

  validates_uniqueness_of :code ,
    :on			  => :create,
    :message  => "sudah wujud. Sila Masukkan kod yang lain"
	
	#validates_format_of :code,
	#					:with				=> /^\w+$/,
	#					:message    => ": kod kursus tidak sah."													

	validates_presence_of :capacity, :time_start, :time_end, :date_plan_start, :date_plan_end,
    :message => ": masukkan nilai."

  validates_presence_of :course, :message=>"masukkan nama kursus"

	#type
	validates_numericality_of :capacity,
    :message => ": hanya mempunyai nombor sahaja."
  							  	
	def validate
    if date_plan_end != nil && date_plan_start != nil
  		if date_plan_end < date_plan_start
  			errors.add_to_base("Tarikh akhir kursus mesti lebih dari tarikh mula kursus")
  		end
    end
  	  
    if date_apply_end != nil && date_plan_start != nil
  		if date_apply_end > date_plan_start
  			errors.add_to_base("Tarikh tutup permohonan mesti sebelum tarikh mula kursus")
  		end
    end
  	  
    if last_date != nil && check_date != nil
  		if date_check < date_apply_end
  			errors.add_to_base("Tarikh semakan mesti lebih dari tarikh akhir permohonan")
  		end
    end


	
	end		
  	
  #def validate_on_create
  #  if self.find_by_name(name)
  #   errors.add(:name, "dah guna")
  #  end
  #end
  	
	def duration_formal
		if self.date_plan_start == self.date_plan_end
			msian_date_formal(self.date_plan_end).upcase
		else
			self.date_plan_start.to_formatted_s(:my_format_day) + " HINGGA " + 
        msian_date_formal(self.date_plan_end).upcase
		end
	end

	def duration_formal_2
		if self.date_plan_start == self.date_plan_end
			msian_date_with_slash(self.date_plan_end).upcase
		else
			msian_date_with_slash(self.date_start) + " HINGGA " + 
        msian_date_with_slash(self.date_end).upcase
		end
	end

  def tempoh
		if self.date_plan_start == self.date_plan_end
			msian_date_with_slash(self.date_plan_end).upcase
		else
			msian_date_with_slash(self.date_plan_start).upcase + " - " + 
        msian_date_with_slash(self.date_plan_end).upcase
		end
	end

  def tempoh_h
		if self.date_plan_start == self.date_plan_end
			msian_date_with_slash(self.date_plan_end).upcase
		else
			msian_date_with_slash(self.date_plan_start).upcase + " HINGGA " + 
        msian_date_with_slash(self.date_plan_end).upcase
		end
	end

  def tempoh_2
		if self.date_plan_start == self.date_plan_end
			msian_date_with_slash(self.date_plan_end).upcase
		else
			self.date_plan_start.to_formatted_s(:my_format_day) + " HINGGA " + 
        msian_date_very_formal_2(self.date_plan_end).upcase
		end
	end

  def tempoh_3
		if !self.date_start
			ds = self.date_plan_start		
		else
			ds = self.date_start
		end

		if !self.date_end
			de = self.date_plan_end		
		else
			de = self.date_end
		end

		if ds == de
			msian_date_with_slash(ds)
		else
			msian_date_with_slash(ds) + " HINGGA " + 
        msian_date_with_slash(de)
		end
	end


	def jumlah_hari
		(self.date_plan_end - self.date_plan_start).to_i #/1.days #+ 1
	end

	def editable?(user)
		can_edit = false
		if user.profile.staff
			if (user.profile.staff.id == self.coordinator1 || user.profile.staff.id == self.coordinator2 || user.profile.staff.id == self.ketua_program || user.profile.staff.id == self.pen_ketua_program )
				can_edit = true
			end
		end

		for r in user.roles
			can_edit = true if r.name == "Admin"
		end

		return can_edit
	end

	def can_still_apply(user)
		t = Time.now
		curr_d= t.strftime("%d")
		curr_m= t.strftime("%m")
		curr_y= t.strftime("%Y")
		#return 1 if user.profile.ic_number == welcometoinstun.to_s
		curr_date = Date.new(curr_y.to_i,curr_m.to_i,curr_d.to_i)
    r = 0
		if self.date_apply_start and self.date_apply_end
			if ( (curr_date >= self.date_apply_start) and (curr_date <= self.date_apply_end) )
				r = 1
			end
		else
			r = 1
		end
		for role in user.roles
			r = 1 if role.name == "Admin"
		end
		
		
		
		return r
	end

	def total_application
		w = "course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"#{w}")
		a.size
	end
	
	def total_inprocess
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 1 #{w}")
		a.size
	end

	def total_selected
		w = "AND course_implementation_id = #{self.id}"	
		a = CourseApplication.find(:all,:conditions=>"student_status_id not in(1,3) #{w}")
		a.size
	end

	def total_rejected
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 3 #{w}")
		a.size
	end

	def total_confirmed
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id in(4,5,6) #{w}")
		a.size
	end
		
	def total_unconfirmed
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 7 #{w}")
		a.size
	end
	
	def total_unknown
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 11 #{w}")
		a.size
	end

	def total_registered
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id in (5,8) #{w}")
		a.size
	end
	
	def total_finished
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 8 #{w}")
		a.size
	end

	def total_cancelled
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>"student_status_id = 12 #{w}")
		a.size
	end
	
	def selected_applicants
		w = "AND course_implementation_id = #{self.id}"
		a = CourseApplication.find(:all,:conditions=>" (student_status_id = 2 OR student_status_id > 3) #{w}")		
	end
	
	def jumlah_kutipan
		w = "AND course_implementation_id = #{self.id}"
		sql = "SELECT sum(fee_amount) FROM course_applications WHERE student_status_id in (5,8) #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.first.sum
	end
	
	def total_make_payment
		w = "AND course_implementation_id = #{self.id}"
		sql = "SELECT count(id) FROM course_applications WHERE student_status_id in (5,8) AND fee_amount notnull #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.first.count
	end
	
	def total_jawab_penilaian
		w = "course_implementation_id = #{self.id}"
		sql = "SELECT distinct(course_application_id) FROM evaluation_answers WHERE #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.size	
	end

	def total_peserta_dinilai
		w = "AND course_implementation_id = #{self.id}"
		sql = "SELECT count(id) FROM course_applications WHERE student_status_id in (5,8) AND markah_penilaian_peserta notnull #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.first.count
	end

	def total_checkin_hostel
		w = "AND course_implementation_id = #{self.id}"
		sql = "SELECT count(id) FROM course_applications WHERE student_status_id in (5,8) AND hostel_id notnull #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.first.count
	end

	def total_jawab_ujian
		w = "course_implementation_id = #{self.id}"
		sql = "SELECT DISTINCT(profile_id) from quizzes q,vw_markah v WHERE q.id=v.q_id AND #{w}"
		a = CourseApplication.find_by_sql(sql)
		a.size	
	end

end
