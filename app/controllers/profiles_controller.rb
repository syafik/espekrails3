# -*- encoding : utf-8 -*-
class ProfilesController < ApplicationController
  layout "standard-layout"

  def initialize
    @states = State.find(:all, :order => "description")
    @genders = Gender.all
    @races = Race.find(:all, :order => "id")
    @handicaps = Handicap.find(:all, :order => "id")
    @profile_statuses = ProfileStatus.all
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

  def list
    #@user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '0'"
    @all_users = User.where("verified = ?", "0").paginate(:page => params[:page], :per_page => 100)
    #@profile_pages, @profiles = paginate :profiles, :per_page => 100
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)
    #render layout: 'standard-layout'
  end

  def list_all
    if params[:huruf] != nil
      @huruf = params[:huruf]
    else
      @huruf = 'A'
    end
    #@user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '1' and login != 'admin' and name ilike '#{@huruf}%'", :order_by => "name ASC"
    @all_users = User.where("verified = ? AND login != ? AND name ILIKE ?", "1", "admin", "#{@huruf}%").order("name ASC").paginate(:page => params[:page], :per_page => 100)
    sqlalpha = "SELECT distinct substr(name,1,1) AS first_char from users";
    @alips = User.find_by_sql(sqlalpha)
    @page = params[:page].to_i

    #sql = "SELECT * FROM users WHERE verified = '1' AND login != 'admin' AND name ilike '#{@huruf}%' ORDER BY name"
    #@all_users = User.find_by_sql(sql)
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)

    #render layout: 'standard-layout'
  end


  def search_akaun
    #@user_pages, @result_users = paginate :user, :per_page => 100, :conditions => "verified = '1' and login != 'admin' and name ilike 'params[:name]'", :order_by => "name ASC"

    #@result_users = User.find_by_sql("select * from users where name ilike '%#{params[:name]}%' order by created_at desc, name asc") if params[:name]
    #if !params[:name].nil? and params[:name].size == 1
    #  params[:name] = nil
    #end
    #if params[:name]
    #  @result_users = User.search(params[:name],:order => 'created_at desc, name asc')
    #else
    #  @result_users = []
    #end


    #@result_users = User.find_by_sql("select * from users where ic_number ilike '%#{params[:ic_number]}%' order by created_at desc, name asc") if params[:ic_number]
    #@result_users = User.find_by_sql("select * from users where login ilike '%#{params[:login]}%' order by created_at desc, name asc") if params[:login]
    if !params[:name].blank? || !params[:ic_number].blank? || !params[:login].blank?
      where = []
      where << "verified = '1' AND login != 'admin'"
      where << "name ILIKE '%#{params[:name]}%'" unless params[:name].blank?
      where << "ic_number ILIKE '%#{params[:ic_number]}%'" unless params[:ic_number].blank?
      where << "login ILIKE '%#{params[:login]}%'" unless params[:login].blank?

      @result_users = User.where(where.join(' AND ')).order("created_at DESC, name ASC").
          paginate(:page => params[:page], :per_page => 100)
    else
      @result_users = []
    end

    #render layout: 'standard-layout'
  end

  def list_notall
    #@user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '2'"
    @all_users = User.where("verified = ?", "2").paginate(:page => params[:page], :per_page => 100)
    #@profile_pages, @profiles = paginate :profiles, :per_page => 100
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)

    #render layout: 'standard-layout'
  end

  def delete_user
    User.find(params[:id]).destroy
    flash[:notice] = "Permohonan telah dibatalkan"
  end

  def setrole
    @user = User.find(params[:profile_id])
    @all_roles = Role.all.select { |r| r.name != UserEngine.config(:guest_role_name) }
    #p "ALL ROLES :::: :::: :::: #{@all_roles}"
    #render layout: 'standard-layout'
  end

  def update_role_old
    if (@user = User.find(params[:id]))
      begin
        User.transaction(@user) do

          roles = params[:user][:roles].collect { |role_id| Role.find(role_id) }
          # add any new roles & remove any missing roles
          roles.each { |role| @user.roles << role if !@user.roles.include?(role) }
          @user.roles.each { |role| @user.roles.delete(role) if !roles.include?(role) }

          @user.save
          flash[:notice] = "Peranan telah dikemaskinikan untuk '#{@user.login}'."
          redirect_to :action => 'setrole', :id => @user
        end
      rescue
        flash[:notice] = 'Peranan tidak boleh dikemaskinikan'
        redirect_to :action => 'list'
      end
    else
      redirect_to :action => 'list'
    end
  end


  def update_role
    set_regular_user_if_empty
    @user = User.find(params["profile_id"])
    if is_roles_contain_trainer_role? && !is_previously_trainer? #new request to be trainer
      create_trainer_profile
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Peranan telah dikemaskinikan untuk '#{@user.login}'."
    else
      flash[:error] = "Peranan Gagal dikemaskinikan untuk '#{@user.login}'."
    end
    redirect_to :action => 'setrole', :profile_id => @user
  end

  def verify
    @user = User.find(params[:profile_id])
    @profile = Profile.find_by_ic_number(@user.ic_number)
    #@profile.ic_number = @user.ic_number
    #@profile.name = @user.name
    #@profile.email = @user.email

    #if @profile.save_with_validation(perform_validation = false)
    @user.verified = 1
    #@user.profile_id = @profile.id
    if @user.update_attributes(params[:user])
      flash[:notice] = "Permohonan untuk '#{@user.login}' telah disahkan"
      redirect_to :action => 'list_all'
    else
      flash[:notice] = "Permohonan untuk '#{@user.login}' tidak dapat disahkan"
      redirect_to :action => 'list'
    end
    #else
    #flash[:notice] = "Permohonan untuk '#{@user.login}' tidak dapat disahkan"
    #redirect_to :action => 'list'
    #  end
  end

  def modrole
    @user = User.find(params[:profile_id])
    @user.verified = 2
    if @user.update_attributes(params[:user])
      flash[:notice] = "Akaun '#{@user.login}' telah digantung"
      redirect_to :action => 'list_notall'
    else
      redirect_to :action => 'list_notall'
    end
  end

  def addrole
    @user = User.find(params[:profile_id])
    @user.verified = 1
    if @user.update_attributes(params[:user])
      flash[:notice] = "Akaun '#{@user.login}' kembali aktif"
      redirect_to :action => 'list_all'
    else
      redirect_to :action => 'list_all'
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)

    #render layout: "standard-layout"
  end

  def show_profile
    @user = User.find(params[:profile_id])
    @profile = Profile.find(@user.profile_id)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)

    #render layout: "standard-layout"
  end

  def view
    @profile = Profile.find(session[:user].profile.id)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
  end

  def view_waris
    @profile = Profile.find(params[:id])
    @relative = Relative.find_by_profile_id(@profile.id)
  end

  def view_khidmat
    @profile = Profile.find(params[:id])
    @employment = Employment.find_by_profile_id(@profile.id)
  end

  def view_akademik
    @profile = Profile.find(params[:id])
    @qualifications = Qualification.find(:all, :conditions => "profile_id = #{@profile.id}")
  end

  def view_kursus
    @profile = Profile.find(session[:user].profile.id)
    #@profile = Profile.find(params[:id])
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id}")
    @courses = Course.find(:all, :order => "name")
  end

  def view_kursus2
    @student = CourseApplication.find(params[:id])
    @profile = Profile.find(@student.profile_id)
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id}")
    @courses = Course.find(:all, :order => "name")
  end

  def view_kursus3
    @student = CourseApplication.find(params[:id])
    @profile = Profile.find(@student.profile_id)
    #@students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id}")
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id} AND (student_status_id=5 or student_status_id=8 or student_status_id=9)", :order => "date_apply")
    @courses = Course.find(:all, :order => "name")
    @employment = Employment.find_by_profile_id(@profile.id)
  end

  def new
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
  end

  def new_peserta
    @courses = Course.all
    @course_implementations = CourseImplementation.all
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
    @course_application = CourseApplication.new
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    @relative = Relative.new(params[:relative])
    @relative.profile = @profile
    @relative.save
    @employment = Employment.new(params[:employment])
    @employment.profile = @profile
    @employment.save
    @qualification = Qualification.new(params[:qualification])
    @qualification.profile = @profile
    @qualification.save

    if @profile.save
      flash[:notice] = 'Profile was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    @qualification = Qualification.find_by_profile_id(@profile.id)
    if @employment
      @job_profile = @employment.job_profile
    else
      @employment = Employment.new
      @job_profile = JobProfile.new
    end
    #render layout: 'standard-layout'
  end

  def edit_peribadi
    @profile = Profile.find(session[:user].profile.id)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
    if @employment
      @job_profile = @employment.job_profile
    else
      @employment = Employment.new
      @job_profile = JobProfile.new
    end
    #render layout: 'standard-layout'
  end

  def update_peribadi
    @profile = Profile.find(session[:user].profile.id)
    logger.info @profile.id
    @user = User.find_by_profile_id(session[:user].profile.id)
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    if @profile.update_attributes(params[:profile])

      @profile.name = @profile.name.gsub(/\'/, '`').to_s.gsub(/\"/, '`')
      @profile.save!

      flash[:notice] = "Profil #{@profile.name} telah dikemaskinikan."
    else
      render :action => 'edit_peribadi'
    end

    @user.email = @profile.email
    @user.ic_number = @profile.ic_number
    @user.name = @profile.name

    if @user.update_attributes(params[:user])
      flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
    else
      render :action => 'edit_peribadi'
    end

    @relative = Relative.find_by_profile_id(@profile.id)
    if @relative
      if @relative.update_attributes(params[:relative])
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'edit_peribadi'
      end
    else
      @relative = Relative.new(params[:relative])
      @relative.profile = @profile
      if @relative.save
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        #render :action => 'edit_peribadi'
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
        render :action => 'edit_peribadi'
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
        render :action => 'edit_peribadi'
      end
    end

    @qualifications = @profile.qualifications
    for q in @qualifications
      q.destroy
    end
    if params[:cert_level_ids] and params[:cert_level_ids].size > 0
      params[:cert_level_ids].size.times do |i|
        q = Qualification.new(:cert_level_id => params[:cert_level_ids][i],
                              :pengkhususan => params[:majors][i],
                              :institution => params[:institutions][i],
                              :year_end => params[:year_ends][i]) if params[:cert_level_ids][i] != ""

        @profile.qualifications.push(q) if q
      end
    end

    redirect_to :action => 'view'

  end

  def edit_waris
    @profile = Profile.find(params[:id])
    @relative = Relative.find_by_profile_id(@profile.id)
  end

  def update_waris
    @profile = Profile.find(params[:id])
    @relative = Relative.find_by_profile_id(@profile.id)

    if @relative.update_attributes(params[:relative])
      flash[:notice] = "Profil #{@profile.name} telah dikemaskinikan."
      redirect_to :action => 'view_waris', :id => @profile
    else
      render :action => 'edit_waris'
    end
  end

  def edit_khidmat
    @profile = Profile.find(params[:id])
    @employment = Employment.find_by_profile_id(@profile.id)
  end

  def update_khidmat
    @profile = Profile.find(params[:id])
    @employment = Employment.find_by_profile_id(@profile.id)

    if @employment.update_attributes(params[:employment])
      flash[:notice] = "Profil #{@profile.name} telah dikemaskinikan."
      redirect_to :action => 'view_khidmat', :id => @profile
    else
      render :action => 'edit_khidmat'
    end
  end

  def edit_akademik
    @profile = Profile.find(params[:id])
    @qualification = Qualification.find_by_profile_id(@profile.id)
  end

  def update_akademik
    @profile = Profile.find(params[:id])
    @qualification = Qualification.find_by_profile_id(@profile.id)

    if @qualification.update_attributes(params[:qualification])
      flash[:notice] = "Profil #{@profile.name} telah dikemaskinikan."
      redirect_to :action => 'view_akademik', :id => @profile
    else
      render :action => 'edit_akademik'
    end
  end

  # suma yang ada ..password2 adalah yang admin tolong tukarkan
  #
  def edit_password
    @profile = Profile.find(session[:user].profile.id)
    @user = User.find_by_profile_id(@profile.id)
  end

  def edit_password2
    @user = User.find(params[:profile_id])
    @profile = Profile.find(@user.profile_id)

    #render layout: 'standard-layout'
  end

  def update_password
    @profile = Profile.find(session[:user].profile.id)
    @user = User.find_by_profile_id(@profile.id)

    if (@user3 = User.authenticate(@profile.user.ic_number, params[:user][:password_old]))
      if (params[:user][:password] != params[:user][:password_confirmation])
        flash[:notice] = "<font color=red>Pengesahan Kata Laluan Baru Tidak Sama</font>"
        redirect_to :action => 'edit_password'
      else
        s = AuthenticatedUser.hashed("salt-#{Time.now}")
        sp = AuthenticatedUser.salted_password(s, AuthenticatedUser.hashed("#{params[:user][:password]}"))
        sql = "UPDATE users SET salt='#{s}' , salted_password='#{sp}' WHERE id=#{@user.id}"
        a = Profile.find_by_sql(sql);
        flash[:notice] = "Tahniah Kerana Penukaran Kata Laluan Berjaya<BR>"
        EspekMailer.user_password(@user.id, params[:user][:password]).deliver
        redirect_to :action => 'view'
      end
    else
      flash[:notice] = "<font color=red>Kata Laluan Tidak Dapat Ditukar. Kata Laluan Lama Tidak Sama.</font>"
      redirect_to :action => 'edit_password'
    end
  end

  def update_password2
    @user = User.find(params[:profile_id])

    #@profile = Profile.find(params[:profile_id])
    #@user = User.find_by_profile_id(@profile.id)
    if (params[:user][:password] != params[:user][:password_confirmation])
      flash[:notice] = "<font color=red>Pengesahan Kata Laluan Baru Tidak Sama</font>"
      redirect_to :action => 'edit_password2', :id => @user.id
    else
      s = AuthenticatedUser.hashed("salt-#{Time.now}")
      sp = AuthenticatedUser.salted_password(s, AuthenticatedUser.hashed("#{params[:user][:password]}"))
      sql = "UPDATE users SET salt='#{s}' , salted_password='#{sp}' WHERE id=#{@user.id}"
      a = Profile.find_by_sql(sql);
      flash[:notice] = "Tahniah Kerana Penukaran Kata Laluan Berjaya<BR>"
      EspekMailer.user_password(@user.id, params[:user][:password]).deliver
      redirect_to :action => 'edit_password2', :id => @user.id
    end
  end


  def update
    @profile = Profile.find(params[:id])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    if @profile.update_attributes(params[:profile])

      @profile.name = @profile.name.gsub(/\'/, '`').to_s.gsub(/\"/, '`')
      #@profile.save(false)
      @profile.save


      @user = User.find(:first,
                        :conditions => ["profile_id = ?", @profile.id])
      @user.email = @profile.email
      #@user.save(false)
      @user.save

      flash[:notice] = '<br>Data Pemohon berjaya dikemaskini.'
    else
      render :action => 'edit'
    end

    @relative = Relative.find_by_profile_id(@profile.id)
    if @relative
      if @relative.update_attributes(params[:relative])
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        render :action => 'edit'
      end
    else
      @relative = Relative.new(params[:relative])
      @relative.profile = @profile
      if @relative.save
        flash[:notice] = 'Data berjaya dikemaskini.'
      else
        #render :action => 'edit_peribadi'
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
        render :action => 'edit'
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
        render :action => 'edit'
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

    EspekMailer.peserta_kursus(session[:user], @profile.id).deliver
    redirect_to :action => 'show', :id => @profile

  end

  def destroy_peserta
    peserta = CourseApplication.find(:all, :conditions => "profile_id = #{params[:profile_id]}")
    #CourseApplication.find_by_profile_id(params[:id]).destroy
    for q in peserta
      q.destroy
    end
    redirect_to :controller => 'course_applications', :action => 'applicant'
  end

  #####################RekodKursusPeserta(copy from user_applications  )##########################################

  def history
    f = "student_status_id"
    s = Array.new
    #s.push("#{f} = 3")
    s.push("#{f} = 5")
    #s.push("#{f} = 6")
    s.push("#{f} = 8")
    s.push("#{f} = 9")
    t = s.join(" OR ")

    @students = CourseApplication.find(:all, :conditions => "profile_id = #{params[:profile_id]} AND (#{t})",
                                       :order => "date_apply DESC,student_status_id")
    @courses = Course.find(:all, :order => "name")

    @profile = Profile.find(params[:profile_id])
    @employment = Employment.find_by_profile_id(@profile.id)

    #render layout: 'standard-layout'
  end


  protected
  def change_password(user)
    begin
      User.transaction(user) do
        user.change_password(params[:user][:password], params[:user][:password_confirmation])
        if user.update_attributes(params[:password])
          flash[:notice] = "Kata Laluan Telah Dikemaskinikan."
        else
          flash[:notice] = 'Kata Laluan Tidak Dapat Ditukar. Sila hubungi Pihak eSPEK.'
        end
      end
    rescue
      flash[:notice] = 'Kata Laluan Tidak Dapat Ditukar. Sila hubungi Pihak eSPEK.'
    end
  end

  private
  def kira(nilai)
    sql = "SELECT * FROM users WHERE verified = '#{nilai}'"
    b = User.find_by_sql(sql)
    return b
  end

  def set_regular_user_if_empty
    default_role = {"role_ids"=>[Role.find_by_name("User").id.to_s]} #regular user
    params[:user] ||= default_role
  end

  def activate_trainer_profile_if_trainer
    trainer_role_id = Role.find_by_name("Pengajar").id.to_s
    if params[:user][:role_ids].include? trainer_role_id
      create_but_profile_exist
    end
  end

  def is_previously_trainer?
    @trainer = Trainer.find_by_profile_id(@user.profile.id)
    return true if !@trainer.blank?
  end

  def is_roles_contain_trainer_role?
    trainer_role_id = Role.find_by_name("Pengajar").id.to_s
    return false if (params["user"]).blank?
    return true if (params[:user][:role_ids].include? trainer_role_id)
    return false
  end

  def deactivate_trainer_profile
    @trainer = Trainer.find_by_profile_id(@user.profile.id)
    @trainer.active = false
    if @trainer.save!
      flash[:notice] = "Profile Trainer Deactivation is Successful"
    else
      flash[:notice] = "Profile Trainer Deactivation is Fail"
    end
  end

  def create_trainer_profile
    ActiveRecord::Base.transaction do
      @trainer = Trainer.new
      @trainer.profile = @user.profile

      @relative = Relative.new
      @relative.profile = @user.profile
      @relative.save
      @employment = Employment.new
      @employment.profile = @user.profile
      @employment.save

      @expertise = Expertise.new
      @expertise.profile = @user.profile
      @expertise.save

      @qualification = Qualification.new
      @qualification.profile = @user.profile
      @qualification.save

      if @trainer.save
        flash[:notice] = 'Tenaga pengajar berjaya disimpan.'
      else
        flash[:notice] = 'Gagal membuat Pengajar'
      end
    end #transaction
  end

end
