# -*- encoding : utf-8 -*-
class EspekMailer < ActionMailer::Base

  def test_mail
    setup_email
  end

  def hostel_reservation(cimp_id)
  	ci = CourseImplementation.find(cimp_id)
	  r = ci.reservations.first
    #@recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email}"
    #@from       = LoginEngine.config(:email_from).to_s
    subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #@headers["cc"]	= "#{Staff.find(@r.to_staff_id).profile.email},#{Staff.find(@r.cc_staff_id).profile.email}"
    #@headers["bcc"]      = "syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
    #@headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  subject += "Tempahan Asrama"
    @course_name = ci.course.name.upcase
    @course_code = ci.code
    @penyelaras1 = ci.penyelaras1.profile.name
    @penyelaras2 = ci.penyelaras2.profile.name
    @date_start = ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = ci.date_end.to_formatted_s(:my_format_4)
    @ditempah_oleh = ci.reservations.first.staff.profile.name
    @tarikh_tempahan = ci.reservations.first.created_on.to_formatted_s(:my_format_4)
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [ci.penyelaras1.profile.email,ci.penyelaras2.profile.email],
      :cc => [Staff.find(r.to_staff_id).profile.email,Staff.find(r.cc_staff_id).profile.email],
      :bcc => ["syedmohd@gmail.com","espek@instun.gov.my","mhafizm@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => subject)
  end

  def domestik_sahkan_tempahan(cimp_id)
  	@ci = CourseImplementation.find(cimp_id)
    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers["cc"]      = "#{Staff.find(@ci.reservations.first.disahkan_oleh).profile.email},#{Staff.find(@ci.reservations.first.to_staff_id).profile.email},#{Staff.find(@ci.reservations.first.cc_staff_id).profile.email}"
    #    @headers["bcc"]      = "syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    @subject += "PENGESAHAN TEMPAHAN ASRAMA"
    @body["course_name"] = @ci.course.name.upcase
    @body["course_code"] = @ci.code
    @body["penyelaras1"] = @ci.penyelaras1.profile.name
    #@body["penyelaras2"] = @ci.penyelaras2.profile.name
    @body["date_start"] = @ci.date_start.to_formatted_s(:my_format_4)
    @body["date_end"]   = @ci.date_end.to_formatted_s(:my_format_4)
    @body["ditempah_oleh"] = nof{@ci.reservations.first.staff.profile.name}
    @body["tarikh_tempahan"] = @ci.reservations.first.created_on.to_formatted_s(:my_format_4)
    @body["tarikh_sah"] = @ci.reservations.first.tarikh_sah.to_formatted_s(:my_format_4)
    @body["disahkan_oleh"] = Staff.find(@ci.reservations.first.disahkan_oleh).profile.name.upcase

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email],
      :cc => [Staff.find(@ci.reservations.first.disahkan_oleh).profile.email,Staff.find(@ci.reservations.first.to_staff_id).profile.email,Staff.find(@ci.reservations.first.cc_staff_id).profile.email],
      :bcc => ["syedmohd@gmail.com","espek@instun.gov.my","mhafizm@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)

  end

  def domestik_sahkan_tempahan_kemudahan(cimp_id)
    @ci = CourseImplementation.find(cimp_id)
    @recipients = "#{Profile.find(@ci.facility_reservations.first.to_profile_id).email},#{Profile.find(@ci.facility_reservations.first.cc_profile_id).email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers["bcc"]      = "syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    @subject += "PENGESAHAN TEMPAHAN KEMUDAHAN KURSUS"
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @penyelaras1 = @ci.penyelaras1.profile.name
    @penyelaras2 = @ci.penyelaras2.profile.name
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    @ditempah_oleh = @ci.facility_reservations.first.profile.name
    @tarikh_tempahan = @ci.facility_reservations.first.created_on.to_formatted_s(:my_format_4)
    @tarikh_sah = @ci.facility_reservations.first.tarikh_sah.to_formatted_s(:my_format_4)
    @disahkan_oleh = Profile.find(@ci.facility_reservations.first.disahkan_oleh).name
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [Profile.find(@ci.facility_reservations.first.to_profile_id).email,Profile.find(@ci.facility_reservations.first.cc_profile_id).email],
      :bcc => ["syedmohd@gmail.com","espek@instun.gov.my","mhafizm@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => subject)
  end

  def hantar_tempahan(cimp_id, staff_id)
    @ci = CourseImplementation.find(cimp_id)

    @staff = Staff.find(staff_id)
    @headers = Hash.new
    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email}, #{@staff.profile.email}"
    #CC : {Ketua Program Kursus; KB R&D}
    #    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #@headers["bcc"]      = "syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
    #    @headers["bcc"]      = "syedmohd@gmail.com,mhafizm@gmail.com"
    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    @subject += "BORANG PERMOHONAN SIJIL"
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @penyelaras = @ci.penyelaras1.profile.name
    @pen_penyelaras = @ci.penyelaras2.profile.name
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email, @staff.profile.email],
      :bcc => ["syedmohd@gmail.com","mhafizm@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)
  end

  def hantar_tempahan_kemudahan(cimp_id)
    @ci = CourseImplementation.find(cimp_id)
    @recipients = "#{Profile.find(@ci.facility_reservations.first.to_profile_id).email},#{Profile.find(@ci.facility_reservations.first.cc_profile_id).email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    @headers["bcc"]      = "syedmohd@gmail.com,mhafizm@gmail.com"
    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    @subject += "TEMPAHAN KEMUDAHAN KURSUS"
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @penyelaras = @ci.penyelaras1.profile.name
    @pen_penyelaras = @ci.penyelaras2.profile.name
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [Profile.find(@ci.facility_reservations.first.to_profile_id).email, Profile.find(@ci.facility_reservations.first.cc_profile_id).email],
      :bcc => ["syedmohd@gmail.com","mhafizm@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)

  end

  def security_approve(no_id)
    @no = Notification.find(no_id)
    @ci = CourseImplementation.find(@no.course_implementation_id)
    @pf = Profile.find(@no.profile_id)

    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email},#{@pf.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers["cc"]  = "ahmadshah@instun.gov.my,fairuszaman@instun.gov.my,ikmal@instun.gov.my"
    #    @headers["bcc"]      = "espek@instun.gov.my"
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  @subject += "Makluman Pelaksanaan Kursus (Pengesahan Seksyen Keselamatan)"
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @penyelaras1 = @ci.penyelaras1.profile.name
    @penyelaras2 = @ci.penyelaras2.profile.name
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    @kuliah = @no.remark
    @tarikh = @no.approved_on.to_formatted_s(:my_format_4)

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email,@pf.email],
      :cc  => ["ahmadshah@instun.gov.my","fairuszaman@instun.gov.my","ikmal@instun.gov.my"],
      :bcc      => "espek@instun.gov.my",
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)

  end

  def security_notify(no_id)
    @no = Notification.find(no_id)
    @ci = CourseImplementation.find(@no.course_implementation_id)

    #    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email},#{@no.user.email}"
    #@recipients = "mhafizm@gmail.com"
    #    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #@headers["cc"]  = "#{@no.user.profile.email},#{@ci.k_program.profile.email}"
    #@headers["cc"]  = "#{@no.user.profile.email}"
    #    @headers["cc"]  = "ahmadshah@instun.gov.my,fairuszaman@instun.gov.my,ikmal@instun.gov.my,#{@no.user.profile.email}"
    #    @headers["bcc"]      = "espek@instun.gov.my"
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  @subject += "Makluman Pelaksanaan Kursus (Seksyen Keselamatan)"
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @penyelaras1 = @ci.penyelaras1.profile.name
    @penyelaras2 = @ci.penyelaras2.profile.name
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email,@no.user.email],
      :cc => ["ahmadshah@instun.gov.my","fairuszaman@instun.gov.my","ikmal@instun.gov.my",@no.user.profile.email],
      :bcc => ["espek@instun.gov.my"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)
  end


  def edit_by_user(ca_id)
    @ca = CourseApplication.find(ca_id)
    @ci = @ca.course_implementation
    @employment = Employment.find_by_profile_id(@ca.profile_id)

    #    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email},#{@ca.profile.email}"
    #    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  @subject += "Peserta Telah Mengemaskini Maklumat Permohonan Kursus"
    #    @body["title"] = @ca.profile.title.description
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    #    @body["nama_peg_melulus"] = @ca.cancel_spv_name
    @student_name = @ca.profile.name
    @jawatan = nof{@employment.job_profile.job_name}
	  @gred = nof{@employment.job_profile.job_grade}
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end = @ci.date_end.to_formatted_s(:my_format_4)
    #    @body["reason"]     = @ca.cancel_reason
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email,@ca.profile.email],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)
  end

  def user_hadir(student_id)
    @ca = CourseApplication.find(student_id)
    @ci = @ca.course_implementation
    @supervisor = Profile.find(@ca.supervisor_profile_id)
    @employment = Employment.find_by_profile_id(@ca.profile_id)

    @recipients = [@ci.penyelaras1.profile.email,@ci.penyelaras2.profile.email,@ca.supervisor_email]
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  @subject += "Pengesahan Kehadiran Kursus"
    @title = @ca.profile.title.description
	  @nama_pegawai = @supervisor.name
	  @nama_pemohon = @ca.profile.name
	  @jawatan = nof{@employment.job_profile.job_name}
	  @gred = nof{@employment.job_profile.job_grade}
    @course_name = @ci.course.name
    @course_code = @ci.code
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    logger.info @ca.date_approval
    @tarikh_pengesahan     = @ca.date_approval.to_formatted_s(:my_format_4) rescue nil

    mail(
      :to => @recipients ,
      :from => @from,
      :subject => @subject,
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    )
  end

  def user_cancel(ca_id)
    @ca = CourseApplication.find(ca_id)
    @ci = @ca.course_implementation
    @employment = Employment.find_by_profile_id(@ca.profile_id)

    @recipients = "#{@ci.penyelaras1.profile.email},#{@ci.penyelaras2.profile.email},#{@ca.cancel_spv_email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
	  @subject += "Pembatalan Permohonan Kursus"
    #    @body["title"] = @ca.profile.title.description
    #    @body["course_name"] = @ci.course.name.upcase
    #    @body["course_code"] = @ci.code
    #    @body["nama_peg_melulus"] = @ca.cancel_spv_name
    #    @body["student_name"] = @ca.profile.name
    #    @body["jawatan"] = nof{@employment.job_profile.job_name}
    #	  @body["gred"] = nof{@employment.job_profile.job_grade}
    #    @body["date_start"] = @ci.date_start.to_formatted_s(:my_format_4)
    #    @body["date_end"]   = @ci.date_end.to_formatted_s(:my_format_4)
    #    @body["reason"]     = @ca.cancel_reason
    @title = @ca.profile.title.description
    @course_name = @ci.course.name.upcase
    @course_code = @ci.code
    @nama_peg_melulus = @ca.cancel_spv_name
    @student_name = @ca.profile.name
    @jawatan = nof{@employment.job_profile.job_name}
	  @gred = nof{@employment.job_profile.job_grade}
    @date_start = @ci.date_start.to_formatted_s(:my_format_4)
    @date_end   = @ci.date_end.to_formatted_s(:my_format_4)
    @reason     = @ca.cancel_reason
    mail(
      :to => @recipients ,
      :subject => @subject,
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    )
  end

  def user_password(user, password)
    @user = User.find(user)
    #@recipients = "#{@user.email}"
    #@from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #@headers["cc"] 	= "#{@user.profile.email}"
    #@headers["cc"]      = "espek@instun.gov.my"
    #@headers["bcc"]      = "espek@instun.gov.my"
    # Email header info
    @subject += "Tukar Kata Laluan"

    # Email body substitutions
    #@body["name"] = "#{user.firstname} #{user.lastname}"
    @login = @user.ic_number
    @password = password
    @sent_on = @sent_on.to_formatted_s(:my_format_7)
    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => @user.email,
      :cc => "espek@instun.gov.my",
      :subject => @subject)

  end

  def user_recorded(user, cid)
    @ci = CourseImplementation.find(cid)
    @recipients = "#{user.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    cc = "espek@instun.gov.my"
    if @ci.k_program
      cc <<  @ci.k_program.profile.email
    end
    if @ci.pen_k_program
      cc << @ci.pen_k_program.profile.email
    end
    if @ci.penyelaras1
      cc << @ci.penyelaras1.profile.email
    end
    if @ci.penyelaras2
      cc << @ci.penyelaras2.profile.email

    end

    @subject += "Permohonan Disimpan"
    @course_name = nof{@ci.course.name.upcase}
    @course_code = nof{@ci.code}
    @course_date_plan_start = nof{@ci.date_plan_start.to_formatted_s(:my_format_4)}
    @course_date_plan_end = nof{@ci.date_plan_end.to_formatted_s(:my_format_4)}
    #@body["coordinator1"] = @ci.penyelaras1.profile.name.upcase if @ci.penyelaras1
    #@body["coordinator1_email"] = @ci.penyelaras1.profile.email if @ci.penyelaras1
    #@body["coordinator1_phone"] = nof{@ci.coordinator1.profile.phone}
    #@body["coordinator2"] = @ci.penyelaras2.profile.name.upcase if @ci.penyelaras2
    #@body["coordinator2_email"] = @ci.penyelaras2.profile.email if @ci.penyelaras2
    #@body["coordinator2_phone"] = nof{@ci.coordinator2.profile.phone}

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => user.email,
      :cc => cc,
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)
  end

  def ketua_jabatan(ca_id)
    @ca = CourseApplication.find(ca_id)
    @recipients = "#{@ca.supervisor_email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    @subject += "Permohonan Disimpan"
    @name = nof{@ca.profile.name.upcase}
    @jawatan = nof{@ca.profile.employments[0].job_profile.job_name.upcase}
    @course_name = nof{@ca.course_implementation.course.name.upcase}
    @course_code = nof{@ca.course_implementation.code}
    if @ca.course_implementation.date_start
      @course_start = nof{@ca.course_implementation.date_start.to_formatted_s(:my_format_4)}
    else
      @course_start = nof{@ca.course_implementation.date_plan_start.to_formatted_s(:my_format_4)}
    end
    if @ca.course_implementation.date_end
      @course_end   = nof{@ca.course_implementation.date_end.to_formatted_s(:my_format_4)}
    else
      @course_end   = nof{@ca.course_implementation.date_plan_end.to_formatted_s(:my_format_4)}
    end

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => @ca.supervisor_email,
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)
  end

  def user_selected(user, cid)
    @ci = CourseImplementation.find(cid)
    setup_email(user)
    @subject += "Anda dipilih menyertai kursus"
    @body["course_name"] = @ci.course.name.upcase
    @body["coordinator1"] = @ci.coordinator1.profile.name.upcase
    @body["coordinator1_email"] = @ci.coordinator1.profile.email
    @body["coordinator1_phone"] = @ci.coordinator1.profile.phone
    @body["coordinator2"] = @ci.coordinator2.profile.name.upcase
    @body["coordinator2_email"] = @ci.coordinator2.profile.email
    @body["coordinator2_phone"] = @ci.coordinator2.profile.phone
  end

  def user_rejected(user, cid)
    @ci = CourseImplementation.find(cid)
    setup_email(user)
    @subject += "Permohonan Ditolak"
    @body["course_name"] = @ci.course.name.upcase
    @body["coordinator1"] = @ci.coordinator1.profile.name.upcase
    @body["coordinator1_email"] = @ci.coordinator1.profile.email
    @body["coordinator1_phone"] = @ci.coordinator1.profile.phone
    @body["coordinator2"] = @ci.coordinator2.profile.name.upcase
    @body["coordinator2_email"] = @ci.coordinator2.profile.email
    @body["coordinator2_phone"] = @ci.coordinator2.profile.phone
  end


  def peserta_kursus(user, pid)
    @pid = Profile.find(pid)
    @officer = Profile.find(user)
    @recipients = "#{@pid.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    #    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    @subject += "KEMASKINI MAKLUMAT PROFILE PESERTA KURSUS INSTUN"
    @profile_email = @pid.email
    @profile_name = @pid.name
    @officer_name = @officer.name
    @officer_post = @officer.designation
    @officer_dept = @officer.opis
    @date_updated = Time.now.strftime('%d/%m/%Y')

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => @pid.email,
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => @subject)

  end

  def send_after_apply_course(user, pid)
    @pid = Profile.find(pid)

  end

  def coordinator_successful(coordinator)
    setup_email(coordinator)

    @subject += "Permohonan Diterima"
    @body["login"] = ""

  end

  def setup_email(user)
    @recipients = "#{user.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
  end

end
