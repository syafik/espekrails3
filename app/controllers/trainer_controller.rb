# -*- encoding : utf-8 -*-
class TrainerController < ApplicationController
  layout "standard-layout"

  def initialize
    @states = State.find(:all, :order => "description")
    @genders = Gender.all
    @races = Race.find(:all, :order => "id")
    @profile_statuses = ProfileStatus.all
    @handicaps = Handicap.find(:all, :order => "id")
    @religions = Religion.find(:all, :order => "id")
    @countries = Country.all
    @marital_statuses = MaritalStatus.all
    @places = Place.find(:all, :conditions => "place_type_id = '2'")
    @relationships = Relationship.all
    @cert_levels = CertLevel.all
    @majors = Major.all
    @job_profiles = JobProfile.all
    @titles = Title.find(:all, :order => "description")
    @course_departments = CourseDepartment.all
    super
  end

  def index
    list
    render :action => 'list'
  end

  def search
    #render layout : 'standard-layout'
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
      #render layout : 'standard-layout'
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
      #render layout : 'standard-layout'
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
      #render layout : 'standard-layout'
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
      #render layout : 'standard-layout'
    rescue
      flash['notice'] = 'Carian Tidak Sah'
      redirect_to :action => 'search'
    end
  end

  def search_by_state
    #@trainers = Trainer.find_by_sql("select * from trainers,profiles WHERE profiles.id = trainers.profile_id AND state_id ILIKE '#{params[:state_id]}'")
    @trainers = params[:state_id].blank? ? [] : Trainer.find_by_sql("select * from trainers,profiles WHERE profiles.id = trainers.profile_id AND state_id = #{params[:state_id]}")
    #render layout: 'standard-layout'
  end

  def eval
    @trainer = Trainer.find(params[:trainer_id])
    @topics = @trainer.topics
    #render layout : 'standard-layout'
  end

  def offer
    @outside = true
    list
    @course_implementation = CourseImplementation.find_by_code(params[:search_course_implementation_code]) if params[:search_course_implementation_code]
    #@course_implementation = CourseImplementation.where("code LIKE ?","#{params[:course_implementation_code]}") if params[:course_implementation_code]
    @trainer = Trainer.find(params[:trainer_id])
    #render layout : 'standard-layout'
  end

  def edit_surat_lantik
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])
    @trainer = Trainer.find(params[:trainer_id])
  end

  def edit_surat_lantik_all
    unless session[:collect_trainers].blank?
      @course_implementation = CourseImplementation.where("course_implementations.id = ?",params[:course_implementation_id].to_i).
        joins("LEFT JOIN courses ON course_implementations.course_id = courses.id
                                                           LEFT JOIN course_departments ON courses.course_department_id = course_departments.id
                                                           LEFT JOIN latest_appoint_references ON course_departments.id = latest_appoint_references.course_department_id").
        select("latest_appoint_references.latest_ref_no, courses.name").first
      trainers = Trainer.where("trainers.id IN (#{session[:collect_trainers].join(",")})").
        joins("LEFT JOIN profiles ON trainers.profile_id = profiles.id
                                 LEFT JOIN states ON profiles.state_id = states.id").
        select("profiles.name, profiles.id as profile_id, trainers.id, address1, address2, address3,
                                  states.description as state_description, profiles.opis, profiles.hod")

      @formatted_trainers_data = []
      trainers.each do |t|
        temp_content = []
        temp_content << t.name

        temp_address = []
        temp_address << t.address1.split(" ").map! { |e| e }.join(" ") unless t.address1.blank?
        temp_address << t.address2.split(" ").map! { |e| e }.join(" ") unless t.address2.blank?
        temp_address << t.address3.split(" ").map! { |e| e }.join(" ") unless t.address3.blank?
        temp_address << t.state_description.split(" ").map! { |e| e.capitalize }.join(" ").upcase unless t.state_description.blank?
        temp_address = temp_address.join("<br />")
        temp_address = temp_address.tr_s(',',',')

        temp_content << temp_address
        temp_content << t.opis
        temp_content << t.hod
        @formatted_trainers_data << temp_content
      end

      @template = "<table style='width: 100%;' border='0'>
                    <tbody>
                    <tr>
                        <td>&nbsp;</td>
                        <td align='right'>
                            <table border='0'>
                                <tbody>
                                <tr>
                                    <td>Ruj. Tuan</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>Ruj. Kami</td>
                                    <td>: #{@rujukan_kami}</td>
                                </tr>
                                <tr>
                                    <td>Tarikh</td>
                                    <td>: #{msian_date_very_formal(Date.today)}
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p><strong><span style='text-decoration: underline;'>SEGERA DENGAN FAX 03-61361073</span></strong></p>
                            <p>

                            </p>
                            <p>_{trainers_name}_</p>

                            <p>Melalui dan Salinan:</p>

                            <p>_{trainers_address}_</p>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan='2'>
                            <p>&nbsp;</p>

                            <p>Tuan/Puan,</p>

                            <p>TAWARAN LANTIKAN PENCERAMAH DI INSTITUT TANAH DAN UKUR NEGARA<br/>TM16/11 - ADOBE ILLUSTRATOR
                                (PEMBANGUNAN JENAMA DAN IDENTITI)<br/>PADA 19 JULAI 2011 HINGGA 22 JULAI 2011</p>

                            <p>Dengan hormatnya saya diarah merujuk kepada perkara di atas.<br/>2. Sukacita dimaklumkan bahawa pegawai
                                seperti nama di atas telah dipilih untuk menghadiri kursus ADOBE ILLUSTRATOR (PEMBANGUNAN JENAMA DAN
                                IDENTITI) (TM16/11) di Institut Tanah dan Ukur Negara (INSTUN), Kementerian Sumber Asli dan Alam
                                Sekitar.</p>

                            <p>3. Bersama-sama ini disertakan dokumen-dokumen berkaitan kursus di atas iaitu:<br/>3.1 Borang Pengesahan
                                Kehadiran seperti di Lampiran A<br/>3.2 Maklumat kursus seperti di Lampiran B</p>

                            <p>4. Peserta dikehendaki membaca / meneliti dokumen-dokumen di para 3 di atas.Peserta juga akan dikenakan
                                bayaran pendaftaran kursus sebanyak RM30.00 (tunai). Resit rasmi akan dikeluarkan bagi membolehkan para
                                peserta membuat tuntutan semula daripada Jabatan/Agensi masing-masing.</p>

                            <p>5. Kerjasama tuan/puan adalah dipohon untuk mengesahkan kehadiran melalui faks seperti di Lampiran A yang
                                disertakan atau secara on-line di laman web INSTUN http://www.instun.gov.my pada atau sebelum 11 Julai,
                                2011.<br/><br/><br/></p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>Sekian, terima kasih.</p>

                            <p>'BERKHIDMAT UNTUK NEGARA'<br/>'MENDAHULUI CABARAN'<br/>'MS ISO 9001:2008 - PENGURUSAN LATIHAN'</p>

                            <p>Saya yang menurut perintah,</p>

                            <p>&nbsp;</p>

                            <p>&nbsp;</p>

                            <p>&nbsp;</p>

                            <p>(DATO' HAJI MOHD SHAFIE BIN ARIFIN)<br/>Pengarah Instun<br/>Institut Tanah dan Ukur Negara<br/>Kementerian
                                Sumber Asli dan Alam Sekitar</p>

                            <p>s.k Fail Timbul</p>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    </tbody>
                </table>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>"
    else
      redirect_to list_trainer_index_url, notice: "Pilih Tenaga Pengajar Dahulu"
    end
  end

  def cetak_surat_lantik_all
    respond_to do |format|
      unless session[:collect_trainers].blank?
        filename = "surat_lantik_#{params[:course_implementation_id]}"
        @content = params[:editor]

        #@course_implementation = CourseImplementation.where("course_implementations.id = ?",params[:course_implementation_id].to_i).
        #    joins("LEFT JOIN courses ON course_implementations.course_id = courses.id
        #                                                     LEFT JOIN course_departments ON courses.course_department_id = course_departments.id
        #                                                     LEFT JOIN latest_appoint_references ON course_departments.id = latest_appoint_references.course_department_id").
        #    select("latest_appoint_references.latest_ref_no, courses.name").first
        trainers = Trainer.where("trainers.id IN (#{session[:collect_trainers].join(",")})").
          joins("LEFT JOIN profiles ON trainers.profile_id = profiles.id
                                   LEFT JOIN states ON profiles.state_id = states.id").
          select("profiles.name, profiles.id as profile_id, trainers.id, address1, address2, address3,
                                    states.description as state_description, profiles.opis, profiles.hod")

        @formatted_trainers_data = []
        trainers.each do |t|
          temp_content = []
          temp_content << t.name

          temp_address = []
          temp_address << t.address1.split(" ").map! { |e| e }.join(" ") unless t.address1.blank?
          temp_address << t.address2.split(" ").map! { |e| e }.join(" ") unless t.address2.blank?
          temp_address << t.address3.split(" ").map! { |e| e }.join(" ") unless t.address3.blank?
          temp_address << t.state_description.split(" ").map! { |e| e.capitalize }.join(" ").upcase unless t.state_description.blank?
          temp_address = temp_address.join("<br />")
          temp_address = temp_address.tr_s(',',',')

          temp_content << temp_address
          temp_content << t.opis
          temp_content << t.hod
          @formatted_trainers_data << temp_content
        end
        format.html
        format.pdf do
          render :pdf => filename,
            :page_size => 'A4'
        end
      else
        redirect_to list_trainer_index_url, notice: "Pilih Tenaga Pengajar Dahulu"
      end
    end
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

  def collect
    @trainer_id = params[:trainer_id].to_i
    session[:collect_trainers] ||= []
    session[:collect_trainers] << @trainer_id
    session[:collect_trainers] = session[:collect_trainers].uniq
    #p session[:collect_trainers]
  end

  def release
    @trainer_id = params[:trainer_id].to_i
    session[:collect_trainers].delete(@trainer_id)
    session[:collect_trainers] = session[:collect_trainers].uniq
    #p session[:collect_trainers]
  end

  def list
    params[:orderby] = "name" if !params[:orderby]
    @orderby = params[:orderby]
    params[:arrow] = "ASC" if !params[:arrow]
    @arrow = params[:arrow]
    @trainers = Trainer.find_by_sql("select * from profiles inner join trainers on profiles.id=trainers.profile_id ORDER BY #{@orderby} #{@arrow}")
    @collect_trainers = session[:collect_trainers] ? session[:collect_trainers] : []
    #render layout : 'standard-layout' if @outside.blank?
  end

  def offer_all
    unless session[:collect_trainers].blank?
      @outside = true
      list
      @course_implementation = CourseImplementation.find_by_code(params[:search_course_implementation_code]) if params[:search_course_implementation_code]
      #@course_implementation = CourseImplementation.where("code LIKE ?","#{params[:course_implementation_code]}") if params[:course_implementation_code]
      #@trainer = Trainer.find(params[:trainer_id])
    else
      redirect_to list_trainer_index_url
    end
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
    #render layout : 'standard-layout'
  end

  def new
    @trainer = Trainer.new
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
    @expertise =Expertise.new
    #render layout : 'standard-layout'
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
      params[:kepakaran].size.times do |i|
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
        params[:kepakaran].size.times do |i|
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
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
        job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
          redirect_to :action => 'show', :id => @trainer
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
    #render layout : 'standard-layout'
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
    #raise @profile.id.inspect
    @employment = Employment.find_by_profile_id(@profile.id)
    if @employment
      arr = params[:job_profile_name].split(",")
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
      job_profile = JobProfile.find(:first, :conditions => "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
      params[:kepakaran].size.times do |i|
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
          :pengkhususan => params[:pengkhususan][i],
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
    @courses = Course.find(:all, :order => "name")
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
    @trainer = Trainer.find(params[:trainer_id])
    @trainer.destroy
    redirect_to :action => 'list'
  end

  def claim_payment_index
    #@profile = current_user.profile #.find(683) should be changed by current user if roles done
    @profile = Profile.find(session[:user].profile.id) #should be changed by current user if roles done
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    #@planning_years = profile.trainer.course_implementations.find_by_sql("SELECT distinct extract(year from date_plan_start)as year from course_implementations").collect(&:year)
    @planning_years = Timetable.find_by_sql("
      SELECT Distinct to_char(tt.date, 'YYYY')as year FROM timetables tt,course_implementations ci,course_implementations_trainers cit,trainers t, courses c
      WHERE  ci.id = tt.course_implementation_id
      AND cit.course_implementation_id =ci.id
      AND cit.trainer_id = t.id
      AND c.id = ci.course_id
      AND t.id = #{@profile.trainer.id}
      ORDER by year DESC
      ").collect(&:year)
    #@course_implementations = profile.trainer.course_implementations
    if params[:tarikh_month].present? && params[:tarikh_year].present?
      @month = params[:tarikh_month]
      @year = params[:tarikh_year]
      @course_slots = Timetable.find_by_sql("
      SELECT tt.id as timetable_id, c.name as name, tt.date as date, tt.topic as topic, ct.name as kategory_pengajar, ct.id as kategory_pengajar_id, EXTRACT(EPOCH FROM (tt.time_end - tt.time_start))/3600 as hour
      , (EXTRACT(EPOCH FROM ((tt.time_end - tt.time_start))/3600)*
      CASE WHEN ct.id=1 THEN (SELECT rate from trainers where id =#{@profile.trainer.id})
      WHEN ct.id=2 THEN (SELECT fasilitator_rate from trainers where id =#{@profile.trainer.id})
      END
      ) as rate_hour
      FROM timetables tt,course_implementations ci,course_implementations_trainers cit,trainers t, courses c, category_trainers ct
      WHERE EXTRACT(month FROM date) = #{@month}
      AND EXTRACT(year FROM date) = #{@year}
      AND ci.id = tt.course_implementation_id
      AND cit.course_implementation_id =ci.id
      AND cit.trainer_id = t.id
      AND c.id = ci.course_id
      AND ct.id = cit.category_trainer_id
      AND t.id = #{@profile.trainer.id}
        ")
    else
      @course_slots =[]
    end

    respond_to do |format|
      format.html
      format.pdf do
        @employment = Employment.find_by_profile_id(@profile.id)
        render :pdf => "BORANG_TUNTUTAN_PENCERAMAH_#{params[:tarikh]}",
          :show_as_html => params[:debug].present?,
          :margin => {:top                => 24.8,
          :bottom        => 25.4,
          :left          => 26.2,
          :right         => 24.8}
      end
    end
  end

  def claim_payment_sent
    claim_list = params[:pilih_tuntutan].collect{|a,b| b }
    claim_list.each do |claim|
      cek_exist= ClaimPayment.where(:trainer_id =>claim.split("|")[4], :timetable_id => claim.split("|")[0])
      if cek_exist.blank?
        claim_row= ClaimPayment.new(:trainer_id =>claim.split("|")[4], :timetable_id => claim.split("|")[0], :total_claim => claim.split("|")[3], :category_trainer_id => claim.split("|")[1], :total_time => claim.split("|")[2], :timetable_date => claim.split("|")[5])
        claim_row.save
      end
    end
    flash[:notice] = "Tuntutan bayaran yang dipilih sudah dihantar"
    redirect_to :action => 'claim_payment_index'
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

    require "prawn"

    pdf = Prawn::Document.new(:page_size => "A4",
      :margin => [36, 50, 36, 50]
    )

    @my_margin = pdf.bounds.absolute_top - 40
    pdf.font "Helvetica"

    pdf.text "", :size => @font_size, :align => :left

    @rujukan_kami = params[:rujukan_kami]
    @tarikh_surat_day = params[:tarikh_surat_day]
    @tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
    @tarikh_surat_month = params[:tarikh_surat_month]
    @tarikh_surat_year = params[:tarikh_surat_year]

    tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
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
        @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
      else
        @tandatangan_jawatan = ""
      end
    else
      @tandatangan_nama = "                     "
      @tandatangan_jawatan = "                     "
    end

    profile = Profile.find(@trainer)

    if (profile.address1 != nil) && (profile.state != nil)
      p_addr1 = profile.address1.split(" ").map! { |e| e }.join(" ")
      p_addr2 = profile.address2.split(" ").map! { |e| e }.join(" ")
      p_addr3 = profile.address3.split(" ").map! { |e| e }.join(" ")
      p_state = profile.state.description.split(" ").map! { |e| e.capitalize }.join(" ")

      p_addr_arr = Array.new
      p_addr_arr.push(p_addr1) if profile.address1 != ""
      p_addr_arr.push(p_addr2) if profile.address2 != ""
      p_addr_arr.push(p_addr3) if profile.address3 != ""
      p_addr_arr.push(p_state.upcase) if profile.state != ""
      p_addr = p_addr_arr.join("\n")
      p_addr = p_addr.tr_s(',', ',')
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

    pdf.y = @my_margin - 50
    pdf.draw_text "Ruj. Tuan", :at => [345, pdf.y], :size => @font_size
    pdf.draw_text ": ", :at => [395, pdf.y], :size => @font_size
    pdf.text "\n", :size => @font_size
    pdf.draw_text "Ruj. Kami", :at => [345, pdf.y], :size => @font_size
    pdf.draw_text ": ", :at => [395, pdf.y], :size => @font_size
    pdf.draw_text "#{@rujukan_kami}", :at => [405, pdf.y], :size => @font_size
    pdf.text "\n", :size => @font_size
    pdf.draw_text "Tarikh", :at => [345, pdf.y], :size => @font_size
    pdf.draw_text ":", :at => [395, pdf.y], :size => @font_size
    pdf.draw_text "#{@tarikh}", :at => [405, pdf.y], :size => @font_size

    pdf.text "\n", :size => @font_size, :align => :left
    profile.fax = "" if profile.fax == nil
    #pdf.text "<b><c:uline>SEGERA DENGAN FAX #{profile.fax}</c:uline></b>\n".html_safe, :size => @font_size, :align => :left
    pdf.text "<b>SEGERA DENGAN FAX #{profile.fax}</b>\n", :size => @font_size, :align => :left, :inline_format => true
    pdf.text "\n", :size => @font_size, :align => :left
    pdf.text "#{nof { profile.name }}\n", :size => @font_size, :align => :left

    pdf.text "\nMelalui dan Salinan:", :size => @font_size, :align => :left
    pdf.text "\n", :size => @font_size, :align => :left
    pdf.text "#{ketua}".upcase, :size => @font_size, :align => :left
    pdf.text "#{office_name}".upcase, :size => @font_size, :align => :left
    pdf.text "#{p_alamat}".upcase, :size => @font_size, :align => :left
    pdf.text "\n", :size => @font_size, :align => :left
    pdf.text "\n", :size => @font_size, :align => :center
    pdf.text "Tuan/Puan,\n\n\n", :size => @font_size, :align => :left
    @per_lines = @perkara.split("\n")
    for per_line in @per_lines
      pdf.text "<b>#{per_line}</b>", :size => @tajuk_font_size, :align => :left, :inline_format => true
    end

    pdf.text "\n#{@perenggan1}", :size => @font_size, :align => :justify
    pdf.text "\n#{@perenggan2}", :size => @font_size, :align => :justify
    pdf.text "\n#{@perenggan3}", :size => @font_size, :align => :justify
    pdf.text "\n#{@perenggan4}", :size => @font_size, :align => :justify
    pdf.text "\n", :size => @font_size

    pdf.start_new_page

    pdf.y = @my_margin

    pdf.text "\n#{@perenggan5}", :size => @font_size, :align => :justify
    pdf.text "\n\n", :size => @font_size, :align => :center

    pdf.text "\n\nSekian, terima kasih.\n\n", :size => @font_size, :align => :left
    pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n", :size => @font_size, :align => :left, :inline_format => true
    pdf.text "<b>'MENDAHULUI CABARAN'</b>\n\n", :size => @font_size, :align => :left, :inline_format => true
    pdf.text "Saya yang menurut perintah,\n\n", :size => @font_size, :align => :left

    if params[:is_cetakan_komputer].to_i == 0
      if RUBY_PLATFORM == "i386-mswin32"
        @signature_file = "public/signatures/#{params[:signature_file]}"
      else
        @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
      end

      if params[:signature_file] and params[:signature_file] != ""
        pdf.image @signature_file, :scale => 0.5
      else
        pdf.text "\n\n\n\n", :size => @font_size, :align => :left
      end
    end

    pdf.text "<b>(#{@tandatangan_nama})</b>", :size => @font_size, :align => :left, :inline_format => true
    pdf.text "#{@tandatangan_jawatan}\n", :size => @font_size, :align => :left
    if @tandatangan_nama != "TUAN MD ALIAS BIN IBRAHIM"
      pdf.text "b.p Pengarah INSTUN", :size => @font_size, :align => :left
    end
    pdf.text "Institut Tanah dan Ukur Negara\n", :size => @font_size, :align => :left
    pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :size => @font_size, :align => :left
    @nota_font_size = 9
    current_y = pdf.y
    pdf.y = pdf.bounds.absolute_bottom - 20
    pdf.draw_text("Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", :at => [70, pdf.y], :size => @nota_font_size) if params[:is_cetakan_komputer].to_i==1

    pdf.render_file(file)

    #if RUBY_PLATFORM == "i386-mswin32"
    #  pdf.save_as("public/surat/" + file) #kat windows
    #else
    #  pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
    #end

  end

end


#@font_size = 12
#@tajuk_font_size = 11
#
#pdf = PDF::Writer.new(:paper => "A4")
#pdf.margins_pt(36, 50, 36, 50) # 36 54 72 90
#@my_margin = pdf.absolute_top_margin - 40
#pdf.select_font("Helvetica")
#
#pdf.text "", :font_size => @font_size, :justification => :left
#
#@rujukan_kami = params[:rujukan_kami]
#@tarikh_surat_day = params[:tarikh_surat_day]
#@tarikh_surat_day = "    " if params[:tarikh_surat_day] == ""
#@tarikh_surat_month = params[:tarikh_surat_month]
#@tarikh_surat_year = params[:tarikh_surat_year]
#
#tarikh_surat = Date.new(@tarikh_surat_year.to_i, @tarikh_surat_month.to_i, @tarikh_surat_day.to_i)
#@tarikh = msian_date_very_formal(tarikh_surat)
#@trainer = params[:surat_lantik_content][:user_id]
#@perkara = params[:surat_lantik_content][:perkara]
#@perenggan1 = params[:surat_lantik_content][:perenggan1]
#@perenggan2 = params[:surat_lantik_content][:perenggan2]
#@perenggan3 = params[:surat_lantik_content][:perenggan3]
#@perenggan4 = params[:surat_lantik_content][:perenggan4]
#@perenggan5 = params[:surat_lantik_content][:perenggan5]
#@signature = Signature.find_by_filename(params[:signature_file])
#if @signature
#  @tandatangan_nama = @signature.person_name.upcase
#  if @signature.person_position != ""
#    @tandatangan_jawatan = @signature.person_position.split(" ").map! { |e| e.capitalize }.join(" ")
#  else
#    @tandatangan_jawatan = ""
#  end
#else
#  @tandatangan_nama = "                     "
#  @tandatangan_jawatan = "                     "
#end
#
#profile = Profile.find(@trainer)
#
#if (profile.address1 != nil) && (profile.state != nil)
#  p_addr1 = profile.address1.split(" ").map! { |e| e }.join(" ")
#  p_addr2 = profile.address2.split(" ").map! { |e| e }.join(" ")
#  p_addr3 = profile.address3.split(" ").map! { |e| e }.join(" ")
#  p_state = profile.state.description.split(" ").map! { |e| e.capitalize }.join(" ")
#
#  p_addr_arr = Array.new
#  p_addr_arr.push(p_addr1) if profile.address1 != ""
#  p_addr_arr.push(p_addr2) if profile.address2 != ""
#  p_addr_arr.push(p_addr3) if profile.address3 != ""
#  p_addr_arr.push(p_state.upcase) if profile.state != ""
#  p_addr = p_addr_arr.join("\n")
#  p_addr = p_addr.tr_s(',', ',')
#else
#  p_addr_arr = Array.new
#  p_addr_arr.push(" ")
#  p_addr_arr.push(" ")
#  p_addr_arr.push(" ")
#  p_addr_arr.push(" ")
#  p_addr = p_addr_arr.join(" \n")
#end
#
#p_alamat = "#{p_addr}"
#office_name = "#{profile.opis}"
#ketua = "#{profile.hod}"
#
#pdf.
#    pdf.y = @my_margin -50
#pdf.add_text(345, pdf.y, "Ruj. Tuan", @font_size)
#pdf.add_text(395, pdf.y, ": ", @font_size)
#pdf.text "\n", :font_size => @font_size
#pdf.add_text(345, pdf.y, "Ruj. Kami", @font_size)
#pdf.add_text(395, pdf.y, ":", @font_size)
#pdf.add_text(405, pdf.y, "#{@rujukan_kami}", @font_size)
#pdf.text "\n", :font_size => @font_size
#pdf.add_text(345, pdf.y, "Tarikh", @font_size)
#pdf.add_text(395, pdf.y, ":", @font_size)
#pdf.add_text(405, pdf.y, "#{@tarikh}", @font_size)
#
#pdf.text "\n", :font_size => @font_size, :justification => :left
#profile.fax = "" if profile.fax == nil
#pdf.text "<b><c:uline>SEGERA DENGAN FAX #{profile.fax}</c:uline></b>\n", :font_size => @font_size, :justification => :left
#pdf.text "\n", :font_size => @font_size, :justification => :left
#pdf.text "#{nof { profile.name }}\n", :font_size => @font_size, :justification => :left
#
#pdf.text "\nMelalui dan Salinan:", :font_size => @font_size, :justification => :left
#pdf.text "\n", :font_size => @font_size, :justification => :left
#pdf.text "#{ketua}".upcase, :font_size => @font_size, :justification => :left
#pdf.text "#{office_name}".upcase, :font_size => @font_size, :justification => :left
#pdf.text "#{p_alamat}".upcase, :font_size => @font_size, :justification => :left
#pdf.text "\n", :font_size => @font_size, :justification => :left
#pdf.text "\n", :font_size => @font_size, :justification => :center
#pdf.text "Tuan/Puan,\n\n\n", :font_size => @font_size, :justification => :left
#@per_lines = @perkara.split("\n")
#for per_line in @per_lines
#  pdf.text "<b>#{per_line}</b>", :font_size => @tajuk_font_size, :justification => :left
#end
#
#pdf.text "\n#{@perenggan1}", :font_size => @font_size, :justification => :full
#pdf.text "\n#{@perenggan2}", :font_size => @font_size, :justification => :full
#pdf.text "\n#{@perenggan3}", :font_size => @font_size, :justification => :full
#pdf.text "\n#{@perenggan4}", :font_size => @font_size, :justification => :full
#pdf.text "\n", :font_size => @font_size
#
#pdf.new_page
#pdf.y = @my_margin
#
#pdf.text "\n#{@perenggan5}", :font_size => @font_size, :justification => :full
#pdf.text "\n\n", :font_size => @font_size, :justification => :center
#
#pdf.text "\n\nSekian, terima kasih.\n\n", :font_size => @font_size, :justification => :left
#pdf.text "<b>`BERKHIDMAT UNTUK NEGARA`</b>\n", :font_size => @font_size, :justification => :left
#pdf.text "<b>'MENDAHULUI CABARAN'</b>\n\n", :font_size => @font_size, :justification => :left
#pdf.text "Saya yang menurut perintah,\n\n", :font_size => @font_size, :justification => :left
#if params[:is_cetakan_komputer].to_i == 0
#  if RUBY_PLATFORM == "i386-mswin32"
#    @signature_file = "public/signatures/#{params[:signature_file]}"
#  else
#    @signature_file = "/aplikasi/www/instun/public/signatures/#{params[:signature_file]}"
#  end
#
#  if params[:signature_file] and params[:signature_file] != ""
#    pdf.image @signature_file, :resize => 0.5
#  else
#    pdf.text "\n\n\n\n", :font_size => @font_size, :justification => :left
#  end
#end
#
#pdf.text "<b>(#{@tandatangan_nama})</b>", :font_size => @font_size, :justification => :left
#pdf.text "#{@tandatangan_jawatan}\n", :font_size => @font_size, :justification => :left
#if @tandatangan_nama != "TUAN MD ALIAS BIN IBRAHIM"
#  pdf.text "b.p Pengarah INSTUN", :font_size => @font_size, :justification => :left
#end
#pdf.text "Institut Tanah dan Ukur Negara\n", :font_size => @font_size, :justification => :left
#pdf.text "Kementerian Sumber Asli dan Alam Sekitar", :font_size => @font_size, :justification => :left
#@nota_font_size = 9
#current_y = pdf.y
#pdf.y = pdf.absolute_bottom_margin - 20
#pdf.add_text(70, pdf.y, "Nota: Surat ini adalah cetakan komputer. Tiada tandatangan diperlukan.", @nota_font_size) if params[:is_cetakan_komputer].to_i==1
#
#
#if RUBY_PLATFORM == "i386-mswin32"
#  pdf.save_as("public/surat/" + file) #kat windows
#else
#  pdf.save_as("/aplikasi/www/instun/public/surat/" + file) #kalu kat bsd
#end
