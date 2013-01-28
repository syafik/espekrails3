# -*- encoding : utf-8 -*-
class ProfilesController < ApplicationController
	layout "standard-layout"
	def initialize
    @states = State.find(:all, :order=>"description")
    @genders = Gender.find_all
    @races = Race.find(:all, :order=>"id")
    @handicaps = Handicap.find(:all, :order=>"id")
    @profile_statuses = ProfileStatus.find_all
    @religions = Religion.find(:all, :order=>"id")
    @countries = Country.find_all
    @marital_statuses = MaritalStatus.find_all
    @places = Place.find(:all, :conditions => "place_type_id = '2'")
    @relationships = Relationship.find_all
    @cert_levels = CertLevel.find_all
    @majors = Major.find_all
    @job_profiles = JobProfile.find_all
    @titles = Title.find(:all, :order=>"description")
    @course_departments = CourseDepartment.find_all
	end

  def index
    list
    render :action => 'list'
  end

  def list
    @user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '0'"
    #@profile_pages, @profiles = paginate :profiles, :per_page => 100
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)
  end

  def list_all
    if params[:huruf] != nil
      @huruf = params[:huruf]
    else
      @huruf = 'A'
    end
    @user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '1' and login != 'admin' and name ilike '#{@huruf}%'", :order_by => "name ASC"
    sqlalpha = "SELECT distinct substr(name,1,1) AS first_char from users";
    @alips  = User.find_by_sql(sqlalpha)
	
	
    sql = "SELECT * FROM users WHERE verified = '1' AND login != 'admin' AND name ilike '#{@huruf}%' ORDER BY name"
    @all_users = User.find_by_sql(sql)
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)


  end


  def search_akaun
    @user_pages, @result_users = paginate :user, :per_page => 100, :conditions => "verified = '1' and login != 'admin' and name ilike 'params[:name]'", :order_by => "name ASC"
    
    #@result_users = User.find_by_sql("select * from users where name ilike '%#{params[:name]}%' order by created_at desc, name asc") if params[:name]
    if !params[:name].nil? and params[:name].size == 1
      params[:name] = nil
    end
    if params[:name]
      @result_users = User.search(params[:name],:order => 'created_at desc, name asc')
    else
      @result_users = []
    end


    @result_users = User.find_by_sql("select * from users where ic_number ilike '%#{params[:ic_number]}%' order by created_at desc, name asc") if params[:ic_number]
    @result_users = User.find_by_sql("select * from users where login ilike '%#{params[:login]}%' order by created_at desc, name asc") if params[:login]
	
  end

  def list_notall
    @user_pages, @all_users = paginate :user, :per_page => 100, :conditions => "verified = '2'"
    #@profile_pages, @profiles = paginate :profiles, :per_page => 100
    @baru = kira(0)
    @aktif = kira(1)
    @tidak = kira(2)

  end

  def delete_user
    User.find(params[:id]).destroy
    flash[:notice] = "Permohonan telah dibatalkan"
    redirect_to :action => 'list'
  end

  def setrole
    @user = User.find(params[:id])
    @all_roles = Role.find_all.select { |r| r.name != UserEngine.config(:guest_role_name) }
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
    if (@user_to_update = User.find(params[:id]))
      user_roles = User.find_by_sql("delete from users_roles where user_id = #{@user_to_update.id}")
		
      if params[:user] and params[:user][:roles].size > 0
        params[:user][:roles].size.times do |i|
          r_id = params[:user][:roles][i]
          user_roles = User.find_by_sql("insert into users_roles(user_id,role_id) values(#{@user_to_update.id},#{r_id})")
        end
        flash[:notice] = "Peranan telah dikemaskinikan untuk '#{@user_to_update.login}'."
      end
      redirect_to :action => 'setrole', :id => @user_to_update
    end
  end

  def verify
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
    @user.verified = 2
    if @user.update_attributes(params[:user])
      flash[:notice] = "Akaun '#{@user.login}' telah digantung"
      redirect_to :action => 'list_notall'
    else
      redirect_to :action => 'list_notall'
    end
  end

  def addrole
    @user = User.find(params[:id])
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
  end

  def show_profile
    @user = User.find(params[:id])
    @profile = Profile.find(@user.profile_id)
    @relative = Relative.find_by_profile_id(@profile.id)
    @employment = Employment.find_by_profile_id(@profile.id)
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
	  @courses = Course.find(:all, :order=>"name")
  end

  def view_kursus2
    @student = CourseApplication.find(params[:id])
    @profile = Profile.find(@student.profile_id)
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id}")
	  @courses = Course.find(:all, :order=>"name")
  end
  
  def view_kursus3
    @student = CourseApplication.find(params[:id])
    @profile = Profile.find(@student.profile_id)
    #@students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id}")
    @students = CourseApplication.find(:all, :conditions => "profile_id = #{@profile.id} AND (student_status_id=5 or student_status_id=8 or student_status_id=9)" , :order=>"date_apply")
	  @courses = Course.find(:all, :order=>"name")
    @employment = Employment.find_by_profile_id(@profile.id)
  end
  
  def new
    @profile = Profile.new
    @relative = Relative.new
    @employment = Employment.new
    @qualification =Qualification.new
  end

  def new_peserta
    @courses = Course.find_all
    @course_implementations = CourseImplementation.find_all
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
  end

  def update_peribadi
    @profile = Profile.find(session[:user].profile.id)
    @user = User.find_by_profile_id(session[:user].profile.id)
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]
    if @profile.update_attributes(params[:profile])
    
      @profile.name = @profile.name.gsub(/\'/, '`').to_s.gsub(/\"/,'`')
      @profile.save(false)
    
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
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
    @user = User.find(params[:id])
    @profile = Profile.find(@user.profile_id)
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
        EspekMailer.deliver_user_password(@user.id, params[:user][:password])
			  redirect_to :action => 'view'
      end
    else
      flash[:notice] = "<font color=red>Kata Laluan Tidak Dapat Ditukar. Kata Laluan Lama Tidak Sama.</font>"
      redirect_to :action => 'edit_password'
    end
  end
  
  def update_password2
    @profile = Profile.find(params[:id])
    @user = User.find_by_profile_id(@profile.id)
    if (params[:user][:password] != params[:user][:password_confirmation])
			flash[:notice] = "<font color=red>Pengesahan Kata Laluan Baru Tidak Sama</font>"
			redirect_to :action => 'edit_password2', :id => @user.id
		else
			s = AuthenticatedUser.hashed("salt-#{Time.now}")
			sp = AuthenticatedUser.salted_password(s, AuthenticatedUser.hashed("#{params[:user][:password]}"))
			sql = "UPDATE users SET salt='#{s}' , salted_password='#{sp}' WHERE id=#{@user.id}"
			a = Profile.find_by_sql(sql);
			flash[:notice] = "Tahniah Kerana Penukaran Kata Laluan Berjaya<BR>"
			EspekMailer.deliver_user_password(@user.id, params[:user][:password])
			redirect_to :action => 'edit_password2', :id => @user.id
		end
  end

  
  def update
    @profile = Profile.find(params[:profile_id])
    @profile.date_of_birth = params[:m_dob]+"/"+params[:d_dob]+"/"+params[:y_dob]

    if @profile.update_attributes(params[:profile])
	  
      @profile.name = @profile.name.gsub(/\'/, '`').to_s.gsub(/\"/,'`')
      @profile.save(false)
    
	  
      @user = User.find(:first,
        :conditions => ["profile_id = ?",@profile.id])
      @user.email = @profile.email
      @user.save(false)
	
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
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
			job_profile = JobProfile.find(:first, :conditions=> "job_grade='#{arr[0]}' and job_name ilike '%#{arr[1]}%'")
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
            
    #EspekMailer.deliver_peserta_kursus(session[:user], @profile.id)
    redirect_to :action => 'show', :id => @profile

  end

  def destroy_peserta
    peserta = CourseApplication.find(:all, :conditions => "profile_id = #{params[:id]}")
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

  	@students = CourseApplication.find(:all, :conditions=>"profile_id = #{params[:id]} AND (#{t})", 
      :order=>"date_apply DESC,student_status_id")
  	@courses = Course.find(:all, :order=>"name")

    @profile = Profile.find(params[:id])
    @employment = Employment.find_by_profile_id(@profile.id)
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

end
