# -*- encoding : utf-8 -*-
class TrainerController < ApplicationController
  layout "standard-layout"
  def initialize
	    @states = State.find(:all, :order=>"description")
	    @genders = Gender.all
	    @races = Race.find(:all, :order=>"id")
	    @profile_statuses = ProfileStatus.all
	    @handicaps = Handicap.find(:all, :order=>"id")
	    @religions = Religion.find(:all, :order=>"id")
	    @countries = Country.all
	    @marital_statuses = MaritalStatus.all
	    @places = Place.find(:all, :conditions => "place_type_id = '2'")
	    @relationships = Relationship.all
	    @cert_levels = CertLevel.all
	    @majors = Major.all
	    @job_profiles = JobProfile.all
	    @titles = Title.find(:all, :order=>"description")
	    @course_departments = CourseDepartment.all
  end
  
  def index
    list
    render :action => 'list'
  end

  def search
    render layout: 'standard-layout'
  end
  
  def search_by_name
    begin
    sql ="Select * from trainers,profiles WHERE "
    where = "trainers.profile_id = profiles.id AND name ILIKE '%#{params[:name]}%'" if params[:name]

     if where != nil
	@trainers = Trainer.find_by_sql(sql + where)
     else
	@trainers = []
     end
      render layout: 'standard-layout'
     rescue
  	flash['notice'] = 'Carian Tidak Sah'
    	redirect_to :action => 'search'
     end	
  end
  
  def search_by_ic
    begin
    sql ="Select * from trainers,profiles WHERE "
    where = "profiles.id = trainers.profile_id AND ic_number ILIKE '%#{params[:ic_number]}%'" if params[:ic_number]
 
     if where != nil
	@trainers = Trainer.find_by_sql(sql + where)
     else
	@trainers = []
     end
     render layout: 'standard-layout'
     rescue
  	flash['notice'] = 'Carian Tidak Sah'
    	redirect_to :action => 'search'
     end	
  end

  def search_by_phone
    begin
    sql ="Select * from trainers,profiles WHERE "
    where = "profiles.id = trainers.profile_id AND mobile ILIKE '%#{params[:phone]}%'" if params[:phone]
    
    if where != nil
        @trainers = Trainer.find_by_sql(sql + where)
     else
        @trainers = []
     end
     render layout: 'standard-layout'
     rescue
        flash['notice'] = 'Carian Tidak Sah'
        redirect_to :action => 'search'
      end
  end
  
  def search_by_expertise
    begin
    sql ="Select * from profiles INNER JOIN trainers on (profiles.id=trainers.profile_id)
    INNER join expertises on (trainers.profile_id=expertises.profile_id) WHERE "
    where = "expertises.kepakaran ILIKE '%#{params[:expertise]}%'" if params[:expertise]
  
    if where != nil
        @trainers = Trainer.find_by_sql(sql + where)
     else
        @trainers = []
     end
     render layout: 'standard-layout'
     rescue
        flash['notice'] = 'Carian Tidak Sah'
        redirect_to :action => 'search'
      end
  end

  def search_by_state
    #@trainers = Trainer.find_by_sql("select * from trainers,profiles WHERE profiles.id = trainers.profile_id AND state_id ILIKE '#{params[:state_id]}'")
    @trainers = params[:state_id].blank? ? [] : Trainer.find_by_sql("select * from trainers,profiles WHERE profiles.id = trainers.profile_id AND state_id = #{params[:state_id]}")
    render layout: 'standard-layout'
  end
  
  def eval
    @trainer = Trainer.find(params[:id])
	@topics = @trainer.topics
  end
  
  def offer
    list
    @course_implementation = CourseImplementation.find_by_code(params[:course_implementation_code]) if params[:course_implementation_code]
    @trainer = Trainer.find(params[:trainer_id])

    render layout: 'standard-layout'
  end
  
  def edit_surat_lantik
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    @trainer = Trainer.find(params[:trainer_id])
    render layout: 'standard-layout'
  end
  
  def rujukan_kami
    @surats = SuratLantikContent.find(:all, :conditions => "course_department_id = #{params[:id]}")
  end
  
  def cetak_surat_lantik
     filename = "surat_lantik_"+ "#{params[:course_implementation_id]}.pdf"
	
	   course_implementation = CourseImplementation.find(params[:course_implementation_id])
     course = Course.find(course_implementation.course_id)
     rujukan = LatestAppointReference.find_by_course_department_id(course.course_department_id)	
     if rujukan
		   rujukan.update_attributes(:latest_ref_no => params[:rujukan_kami])
	   else
		   rujukan = LatestAppointReference.new(:latest_ref_no => params[:rujukan_kami], :course_department_id => course.course_department_id)
		   rujukan.save
	   end
	   params[:surat_lantik_content][:is_cetakan_komputer] = params[:is_cetakan_komputer]
	   params[:surat_lantik_content][:format_surat] = 1
	   params[:surat_lantik_content][:course_department_id] = course.course_department_id
     params[:surat_lantik_content][:course_implementation_id] = params[:course_implementation_id]
	   params[:surat_lantik_content][:ref_no] = params[:rujukan_kami]
	   params[:surat_lantik_content][:letter_date] = params[:tarikh_surat_month]+"/"+params[:tarikh_surat_day]+"/"+params[:tarikh_surat_year]
	   ads_letter = SuratLantikContent.find_by_course_implementation_id(params[:course_implementation_id])
	   if ads_letter
		   ads_letter.update_attributes(params[:surat_lantik_content])
	   else
		   new_ads_letter = SuratLantikContent.new(params[:surat_lantik_content])
		   new_ads_letter.save!
	   end	
	
	   gen_pdf_all_format_1 (filename) if params[:format_surat].to_i == 1
     redirect_to("/surat/" + filename)
  end
  
  def list
      params[:orderby] = "name" if !params[:orderby]
  	  @orderby = params[:orderby]
  	  params[:arrow] = "ASC" if !params[:arrow]
  	  @arrow = params[:arrow]
    @trainers = Trainer.find_by_sql("select * from profiles inner join trainers on profiles.id=trainers.profile_id ORDER BY #{@orderby} #{@arrow}")
  end

  def show
    @trainer = Trainer.find(params[:id])
    @profile = Profile.find(@trainer.profile_id)
    @relative = Relative.find_by_profile_id(@trainer.profile_id)
    @employment = Employment.find_by_profile_id(@profile.id)
    #@trainer.profile = Profile.find(@trainer.profile_id)
    #@profile = @trainer.profile
    #@trainer = Trainer.find(params[:id])
    #@trainer.profile.qualifications.qualification_category.description
    #@qualification = @trainer.profile.qualifications
    render layout: 'standard-layout'
  end

  def new
    @trainer = Trainer.new
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
    @expertise =Expertise.new
  end

  def new_but_profile_exist
    @trainer = Trainer.new
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
    @expertise =Expertise.find_by_profile_id(@profile.id)
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    @trainer = Trainer.new(params[:trainer])
    @trainer.profile = @profile

    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save
    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save

	if params[:kepakaran]
		params[:kepakaran].size.times do|i|
			exp = Expertise.new(:kepakaran => params[:kepakaran][i])
			@profile.expertises.push(exp)
		end
	end

	if params[:cert_level_ids]
		params[:cert_level_ids].size.times do |i|
			q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
				                  #:major_id => params[:major_ids][i],
								  :institution => params[:institutions][i],
								  :year_end => params[:year_ends][i])
		
			@profile.qualifications.push(q)
		end
	end


    if @trainer.save
      flash[:notice] = 'Tenaga pengajar berjaya disimpan.'
      redirect_to :action => 'show', :id => @trainer
    else
	  @profile.destroy
      render :action => 'new'
    end
  end

  def create_but_profile_exist
    #@profile = Profile.find_by_ic_number(session[:user].profile.ic_number)
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification =Qualification.find_by_profile_id(@profile.id)
    @expertise =Expertise.find_by_profile_id(@profile.id)
    @trainer = Trainer.new(params[:trainer])
    @trainer.profile = @profile

	if @trainer.save
		#if @profile.update_attributes(params[:profile])
		#	flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
		#else
		#	render :action => 'new_but_profile_exist'
		#end
	
	@expertises = @profile.expertises
	for exp in @expertises
	     exp.destroy
	end	
	if params[:kepakaran]
		params[:kepakaran].size.times do|i|
			exp = Expertise.new(:expertise => params[:kepakaran][i])
			@profile.expertises.push(exp)
		end
	end	

	@qualifications = @profile.qualifications
		for q in @qualifications
			q.destroy
		end
		if params[:cert_level_ids]
		  params[:cert_level_ids].size.times do |i|
			q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
				                  :pengkhususan => params[:pengkhususan][i],
								  :institution => params[:institutions][i],
								  :year_end => params[:year_ends][i])
		
			@profile.qualifications.push(q)
		  end
		end

	@employment = Employment.find_by_profile_id(@profile.id)
		if @employment
			arr = params[:job_profile_name].split(",")
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
			params[:employment][:job_profile_id] = job_profile.id if job_profile

			if @employment.update_attributes(params[:employment])
				flash[:notice] = 'Data berjaya dikemaskini.'
			else
				render :action => 'new_but_profile_exist'
			end
		else
			@employment = Employment.new(params[:employment])
			@employment.profile = @profile
			arr = params[:job_profile_name].split(",")
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
			@employment.job_profile_id = job_profile.id if job_profile
			if @employment.save
				flash[:notice] = 'Data berjaya dikemaskini.'
			else
				render :action => 'new_but_profile_exist'
			end
		end

		@relative = Relative.find_by_profile_id(@profile.id)
		if @relative
			if @relative.update_attributes(params[:relative])
				flash[:notice] = 'Data berjaya dikemaskini.'
				redirect_to :action => 'show', :id => @trainer
			else
				render :action => 'new_but_profile_exist'
			end
		else
			@relative = Relative.new(params[:relative])
			@relative.profile = @profile
			if @relative.save
				flash[:notice] = 'Data berjaya dikemaskini.'
				redirect_to :action => 'show', :id=> @trainer
			else
				render :action => 'new_but_profile_exist'
			end
		end

	else
		flash[:notice] = 'Data gagal disimpan, sila cuba sekali lagi'
		render :action => 'new_but_profile_exist'
	end

  end
  
  def edit
    @trainer = Trainer.find(params[:id])
    @qualification = Qualification.find_by_profile_id(@trainer.profile_id)
    @expertise = Expertise.find_by_profile_id(@trainer.profile_id)
    #@experience = Experience.find_by_profile_id(@trainer.profile_id)
    @relative = Relative.find_by_profile_id(@trainer.profile_id)
    @employment = Employment.find_by_profile_id(@trainer.profile_id)
    @trainer.profile = Profile.find(@trainer.profile_id)
    @profile = @trainer.profile
    render layout: 'standard-layout'
  end

  def update
    @trainer = Trainer.find(params[:id])
    @trainer.profile = Profile.find(@trainer.profile_id)
    
	if @trainer.update_attributes(params[:trainer])
    	flash[:notice] = 'Data Tenaga Pengajar Telah Dikemaskinikan'
    	#redirect_to :action => 'show', :id => @trainer
    else
    	render :action => 'edit'
    end

	@profile = @trainer.profile
	if @profile.update_attributes(params[:profile])
      	flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
        else
      	render :action => 'edit'
        end

	@relative = Relative.find_by_profile_id(@profile.id)
	if @relative
		if @relative.update_attributes(params[:relative])
			flash[:notice] = 'Data berjaya dikemaskini.'
		else
			render :action => 'new_but_profile_exist'
		end
	else
		@relative = Relative.new(params[:relative])
		@relative.profile = @profile
		if @relative.save
			flash[:notice] = 'Data berjaya dikemaskini.'
		else
			render :action => 'new_but_profile_exist'
		end
	end

	@employment = Employment.find_by_profile_id(@profile.id)
	if @employment
		arr = params[:job_profile_name].split(",")
		job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
		params[:employment][:job_profile_id] = job_profile.id if job_profile
	
		if @employment.update_attributes(params[:employment])
			flash[:notice] = 'Data berjaya dikemaskini.'
		else
			render :action => 'new_for_logged_in_user'
		end
	else
		@employment = Employment.new(params[:employment])
		@employment.profile = @profile
		arr = params[:job_profile_name].split(",")
		job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
		@employment.job_profile_id = job_profile.id if job_profile
		if @employment.save
			flash[:notice] = 'Data berjaya dikemaskini.'
		else
			render :action => 'new_for_logged_in_user'
		end
	end
	
	@expertises = @profile.expertises
	for exp in @expertises
	     exp.destroy
	end	
	if params[:kepakaran]
		params[:kepakaran].size.times do|i|
			exp = Expertise.new(:kepakaran => params[:kepakaran][i])
			@profile.expertises.push(exp) if exp
		end
	end	

	@qualifications = @profile.qualifications
	for q in @qualifications
		q.destroy
	end
	if params[:cert_level_ids] and params[:cert_level_ids].size > 0
		params[:cert_level_ids].size.times do |i|
			q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
				                  :pengkhususan=> params[:pengkhususan][i],
								  :institution => params[:institutions][i],
								  :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""
		
			@profile.qualifications.push(q) if q
		end
	end
	
	redirect_to :action => 'show', :id => @trainer
  end

  def new_teaching_course
    @trainer = Trainer.find(params[:id])
	@trainer.profile = Profile.find(@trainer.profile_id)
	@profile = @trainer.profile
	@courses = Course.find(:all, :order=>"name")
  end

  def create_teaching_course
    @trainer = Trainer.find(params[:id])
	@profile = @trainer.profile
    
	@trainer.courses.push(Course.find(@params[:course_ids]))
	#@trainer.course_ids = @params[:course_ids]
	#@trainer.update_attributes
	#render :action => 'show', :id=>@trainer
	redirect_to("/trainer/show/#{@trainer.id}?what=show_course")
  end

  def remove_course
    @trainer = Trainer.find(params[:id])
	#new_courses = Array.new
	#for course in @trainer.courses
    #  new_courses.push(course.id) if course.id != params[:course_id].to_i
	#end
	#@trainer.course_ids = []
	#@trainer.course_ids = new_courses
	a = Student.find_by_sql("delete from courses_trainers where course_id=#{params[:course_id]} and trainer_id=#{@trainer.id}")
	redirect_to("/trainer/show/#{@trainer.id}?what=show_course")
  end

  def new_qualification
    @trainer = Trainer.find(params[:id])
	@profile = @trainer.profile
	@qualification = Qualification.new
  end
  def create_qualification
    @trainer = Trainer.find(params[:id])
	@trainer.profile.qualifications.push(Qualification.new(params[:qualification]))
	redirect_to("/trainer/show/#{@trainer.id}?what=show_qualification")
  end

  def remove_qualification
    @qualification = Qualification.find(params[:qualification_id])
    @qualification.destroy
	redirect_to("/trainer/show/#{params[:id]}?what=show_qualification")
  end  
  def destroy
    @trainer = Trainer.find(params[:id])
    @trainer.destroy
    redirect_to :action => 'list'
  end
  
  #def new_expertise
  #  @trainer = Trainer.find(params[:id])
  #	@profile = @trainer.profile
  #	@expertise = Expertise.new
  #  end
  #def create_expertise
  #  @trainer = Trainer.find(params[:id])
  #	@trainer.profile.expertises.push(Expertise.new(params[:expertise]))
  #	redirect_to("/trainer/show/#{@trainer.id}?what=show_expertise")
  #end

  #def remove_expertise
  #  @expertise = Expertise.find(params[:expertise_id])
  #  @expertise.destroy
  #	redirect_to("/trainer/show/#{params[:id]}?what=show_expertise")
  #end
  private
  def gen_pdf_all_format_1 (file)
		@font_size = 12
		@tajuk_font_size = 11

		pdf = PDF::Writer.new(:paper=>"A4")
		pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
		@my_margin = pdf.absolute_top_margin - 40
		pdf.select_font("Helvetica")
  
		pdf.text "", :font_size => @font_size, :justification => :left
	
		@rujukan_kami = params[:rujukan_kami]
		@tarikh_surat_day = params[:tarikh_surat_day]
		@tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
		@tarikh_surat_month = params[:tarikh_surat_month]
		@tarikh_surat_year = params[:tarikh_surat_year]
	
		tarikh_surat = Date.new(@tarikh_surat_year.to_i,@tarikh_surat_month.to_i,@tarikh_surat_day.to_i)
		@tarikh = msian_date_very_formal(tarikh_surat)
		@trainer = params[:surat_lantik_content][:user_id]
		@perkara = params[:surat_lantik_content][:perkara]
		@perenggan1 = params[:surat_lantik_content][:perenggan1]
		@perenggan2 = params[:surat_lantik_content][:perenggan2]
		@perenggan3 = params[:surat_lantik_content][:perenggan3]
		@perenggan4 = params[:surat_lantik_content][:perenggan4]
		@perenggan5 = params[:surat_lantik_content][:perenggan5]
    @signature = Signature.find_by_filename(params[:signature_file])
    if @signature
  		@tandatangan_nama = @signature.person_name.upcase
  		if @signature.person_position != ""
  			@tandatangan_jawatan = @signature.person_position.split(" ").map! {|e| e.capitalize}.join(" ")
  		else
  			@tandatangan_jawatan = ""
  		end
  	else
  		@tandatangan_nama    = "                     "
  		@tandatangan_jawatan = "                     "	
  	end
		
		profile = Profile.find(@trainer)

		if (profile.address1 != nil) && (profile.state != nil)
			p_addr1 = profile.address1.split(" ").map! {|e| e}.join(" ")
			p_addr2 = profile.address2.split(" ").map! {|e| e}.join(" ")
			p_addr3 = profile.address3.split(" ").map! {|e| e}.join(" ")
			p_state = profile.state.description.split(" ").map! {|e| e.capitalize}.join(" ")

			p_addr_arr = Array.new
			p_addr_arr.push(p_addr1) if profile.address1 != ""
			p_addr_arr.push(p_addr2) if profile.address2 != ""
			p_addr_arr.push(p_addr3) if profile.address3 != ""
			p_addr_arr.push(p_state.upcase) if profile.state != ""
			p_addr = p_addr_arr.join("\n")
			p_addr = p_addr.tr_s(',' , ',')
		else
			p_addr_arr = Array.new
			p_addr_arr.push(" ")
			p_addr_arr.push(" ")
			p_addr_arr.push(" ")
			p_addr_arr.push(" ")
			p_addr = p_addr_arr.join(" \n")
		end
		
		p_alamat = "#{p_addr}"
    office_name = "#{profile.opis}"
    ketua = "#{profile.hod}" 

		pdf.y = @my_margin -50
		pdf.add_text(345, pdf.y, "Ruj. Tuan", @font_size)
		pdf.add_text(395, pdf.y, ": ", @font_size)
		pdf.text "\n", :font_size => @font_size
		pdf.add_text(345, pdf.y, "Ruj. Kami", @font_size)
		pdf.add_text(395, pdf.y, ":", @font_size)
		pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @font_size)
		pdf.text "\n", :font_size => @font_size
		pdf.add_text(345, pdf.y, "Tarikh", @font_size)
		pdf.add_text(395, pdf.y, ":", @font_size)
		pdf.add_text(405, pdf.y, "#{@tarikh}", @font_size)

		pdf.text "\n", :font_size => @font_size, :justification => :left
		profile.fax = "" if profile.fax == nil
    pdf.text "<b><c:uline>SEGERA DENGAN FAX #{profile.fax}</c:uline></b>\n", :font_size => @font_size, :justification => :left
		pdf.text "\n", :font_size => @font_size, :justification => :left
		pdf.text "#{nof{profile.name}}\n", :font_size => @font_size, :justification => :left

    pdf.text "\nMelalui dan Salinan:", :font_size => @font_size, :justification => :left
		pdf.text "\n", :font_size => @font_size, :justification => :left
		pdf.text "#{ketua}".upcase, :font_size => @font_size, :justification => :left
		pdf.text "#{office_name}".upcase, :font_size => @font_size, :justification => :left
		pdf.text "#{p_alamat}".upcase, :font_size => @font_size, :justification => :left
    pdf.text "\n", :font_size => @font_size, :justification => :left
		pdf.text "\n", :font_size => @font_size, :justification => :center
		pdf.text "Tuan/Puan,\n\n\n", :font_size => @font_size, :justification => :left
		@per_lines = @perkara.split("\n")
		for per_line in @per_lines
			pdf.text "<b>#{per_line}</b>", :font_size => @tajuk_font_size, :justification => :left
		end
		
    pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
		pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full
		pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
		pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
		pdf.text "\n", :font_size => @font_size
		
		pdf.new_page  
		pdf.y = @my_margin

    pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full
    pdf.text "\n\n", :font_size => @font_size, :justification => :center

		pdf.text "\n\nSekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
		pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n", :font_size => @font_size, :justification => :left
		pdf.text "<b>'MENDAHULUI CABARAN'</b>\n\n", :font_size => @font_size, :justification => :left
		pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left
		if params[:is_cetakan_komputer].to_i == 0
  		if RUBY_PLATFORM == "i386-mswin32"
  			@signature_file = "public/signatures/#{params[:signature_file]}"
  		else
  			@signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
  		end

  		if params[:signature_file] and params[:signature_file] != ""
  			pdf.image @signature_file, :resize => 0.5
  		else
  			pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left
  		end
  	end

	pdf.text "<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
	pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
        if @tandatangan_nama != "TUAN MD ALIAS BIN IBRAHIM"
        	pdf.text "b.p Pengarah INSTUN", :font_size => @font_size, :justification => :left
        end
	pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @font_size, :justification => :left
	pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left
		@nota_font_size = 9
		current_y = pdf.y
		pdf.y = pdf.absolute_bottom_margin - 20
		pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:is_cetakan_komputer].to_i==1

  
	if RUBY_PLATFORM == "i386-mswin32"
		pdf.save_as("public/surat/" + file) #kat windows
	else
		pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
	end

  end
  
end
