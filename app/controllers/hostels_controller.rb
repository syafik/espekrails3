# -*- encoding : utf-8 -*-
class HostelsController < ApplicationController
  layout "standard-layout"
  def initialize
    @religions = Religion.find(:all, :order=>"id")
    @races = Race.find(:all, :order=>"id")
    @marital_statuses = MaritalStatus.all
    @handicaps = Handicap.find(:all, :order=>"id")
    @states = State.find(:all, :order=>"description")
    @relationships = Relationship.all
    @titles = Title.find(:all, :order=>"description")
    @course_departments = CourseDepartment.all
    @hostel_types = HostelType.find(:all, :order=>"id")
    @hostel_statuses = HostelStatus.find(:all, :order=>"id")
    @hostel_blocks = HostelBlock.find(:all, :order=>"id")
    @genders = Gender.find(:all, :order=>"id")
    @color_close = '#aaaaaa'
    @color_kosong = '#aaffaa'
  end
  
  def blank
  	render :text=> " "
  end
  
  def index
    redirect_to :action => 'list'
    #    render :action => 'list'
  end

  def senggara
  	list
  end
  
  def list_tutup
  	@hostels = Hostel.find_all_by_hostel_status_id(2)
    render layout: "standard-layout"
  end
  
  def list
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
    @color_close = '#aaaaaa'
    @color_kosong = '#aaffaa'
    render :layout => "standard-layout"
  end

  def lihat
    room = params[:room]
    level = params[:level]
    block = params[:block]

    @hostels = Hostel.find_by_sql("SELECT * FROM hostels WHERE block_id = #{block.to_i} AND level = #{level.to_i} AND room = #{room.to_i} ORDER BY 1")
    @room = @hostels.first
    @room = Hostel.find(params[:id]) if params[:id]
    @hostel_profile = HostelProfile.find_by_hostel_id(@room.id)
    render :layout => 'scaffold'
  end
  
  def show
    room = params[:room]
    level = params[:level]
    block = params[:block]

    @hostels = Hostel.find_by_sql("SELECT * FROM hostels WHERE block_id = #{block.to_i} AND level = #{level.to_i} AND room = #{room.to_i} ORDER BY 1")
    @room = @hostels.first
    @room = Hostel.find(params[:id]) if params[:id]
    @hostel_profile = HostelProfile.find_by_hostel_id(@room.id)
    render :layout => 'scaffold'
  end

  def new_one
    @hostel = Hostel.new
  end

  def create_one
    blok = params[:blok]
    jum_aras = params[:jum_aras]
    jum_bilik = params[:jum_bilik]
    jum_katil = params[:jum_katil]
    rate = params[:rate]
    rate2 = params[:rate2]
    gender = params[:gender]
    redirect_to :action => 'new_two', :blok => blok, :jum_aras => jum_aras, :jum_bilik => jum_bilik, :jum_katil => jum_katil, :rate => rate, :rate2 => rate2, :gender => gender
  end
  
  def new_two
    @hostel_block = HostelBlock.new
    @hostel = Hostel.new
  end

  def create_two
    jum_aras = params[:jum_aras]
    jum_bilik = params[:jum_bilik]
    jum_katil = params[:jum_katil]
    rate = params[:rate]
    rate2 = params[:rate2]
    jum_aras = jum_aras.to_i
    
    bilik = params[:bilik]
    katil = params[:katil]
    gender = params[:gender]
    type = params[:type]
    
    #Add blok and get id dulu...
    @hostel_block = HostelBlock.new(params[:hostel_block])
    @hostel_block.save
    
    
    x=0   
    y=1
    z=1
    jum_aras.times do
      bil_bilik = bilik[x]
      bil_katil = katil[x]
      bil_bilik = bil_bilik.to_i
      bil_katil = bil_katil.to_i
      
      r=1
      bil_bilik.times do
        #bil_katil.times do  #kena tambah based on katil kan??
        @hostel = Hostel.new(params[:hostel])
        @hostel.block_id = @hostel_block.id
        @hostel.level = y
        @hostel.room = r
        @hostel.gender_id = gender[x]
        @hostel.hostel_type_id = type[x]
        @hostel.hostel_status_id = 1
        @hostel.capacity = bil_katil
        @hostel.room_name = y.to_s+"-"+z.to_s
        @hostel.room_no = z
        @hostel.save
        #end
        r=r+1
        z=z+1
      end
      
      #render :text => bilik[x]
      y=y+1
      x=x+1
    end
    
    if @hostel.save
      flash[:notice] = 'Asrama sudah ditambah.'
      redirect_to :action => 'list'
    else
      render :action => 'new_one'
    end
    
  end
  
  
  def new
    @hostel = Hostel.new
  end

  def create
    @hostel = Hostel.new(params[:hostel])
    if @hostel.save
      flash[:notice] = 'Hostel was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    #@hostel = Hostel.find(params[:id])
    #@hostel_block = HostelBlock.find(params[:block])
    
    room = params[:room]
    level = params[:level]
    block = params[:block]

    #@hostels = Hostel.find_by_sql("SELECT * FROM hostels WHERE block_id = #{block.to_i} AND level = #{level.to_i} AND room = #{room.to_i} ORDER BY id ASC")
    #@hostel = @hostels.first
    @hostel = Hostel.find(params[:id]) if params[:id]
    @hostel_block = @hostel.block
    render :layout => 'scaffold'
  end

  def update

    @hostel = Hostel.find(params[:id])
    params[:katil].size.times do |i|
      @hostel = Hostel.find(params[:katil][i])
      @hostel.gender_id        = params[:gender][i]
      @hostel.hostel_type_id   = params[:type][i]
      @hostel.hostel_status_id = params[:status][i]
      @hostel.rate = params[:rate][i]
		
      if @hostel.hostel_status_id == 2
        @hostel.sebab_tutup = params[:hostel_sebab_ditutup]
        @hostel.tarikh_ditutup = Time.now
      end

      if @hostel.hostel_status_id == 1
        @hostel.sebab_tutup = ''
        @hostel.tarikh_ditutup = nil
      end

      if @hostel.update_attributes(params[:hostel])
        flash[:notice] = 'Bilik telah berjaya dikemaskini.'
      else
        render :action => 'edit'
      end
    end

    @hostel.hostel_fixtures = []
    @hfs = HostelFixture.find(:all, :order=>"description")
    for fixture in @hfs
      if params[:quantities]["#{fixture.id}"] != ""
        @hostel.hostel_fixtures.push_with_attributes(fixture, :quantity=>params[:quantities]["#{fixture.id}"], :remark=>params[:remarks]["#{fixture.id}"])
      end
    end



    redirect_to("/hostels/show/#{@hostel.id}?block=#{@hostel.block_id}&level=#{@hostel.level}&room=#{@hostel.room}") and return

  end

  def destroy
    Hostel.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def list_active_course
  	chkin_by_course
  end
  
  def chkin_by_course
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 1)
	  oneweekago     = today - (7 * (60 * 60 * 24))
	  threedayslater = today + (3 * (60 * 60 * 24))

    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    @day_week, @month_week, @year_week = oneweekago.day, oneweekago.month, oneweekago.year
    @day_three, @month_three, @year_three = threedayslater.day, threedayslater.month, threedayslater.year
      
	  if params[:report1]
	  	if params[:report1][:input_tarikh_mula] != nil
        tarikh1 = params[:report1][:input_tarikh_mula]
        tarikhi = tarikh1.split('/')
        d = tarikhi[0]
        m = tarikhi[1]
        y = tarikhi[2]
        date_start = m+"/"+d+"/"+y
	  		@report_date_from = tarikh1
      end
    end
          
    #date_start = params[:report1][:input_tarikh_mula]
    #date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if !params[:report1]
    date_start_week = "#{@month_week}/#{@day_week}/#{@year_week}" if !params[:report1]
    date_end_three = "#{@month_three}/#{@day_three}/#{@year_three}" if !params[:report1]
    #date_start = "#{@month_next}/#{@day_next}/#{@year_next}" if (params[:report1] and params[:report1][:input_tarikh_mula] == "")

	  if params[:report1]
      begin
        @students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE date_start = '#{date_start}' order by date_start ASC")
      rescue
        redirect_to :action => 'chkin_by_course'
      end
	  else
      begin
        @students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE (date_start BETWEEN '#{date_start_week}' AND '#{date_end_three}' AND date_end>='#{today}' OR date_start<='#{today}' AND date_end>='#{today}')order by date_start ASC")
        #@students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE course_status_id ='1' AND ('#today' between date_start AND date_end order by date_start ASC")
      rescue
        redirect_to :action => 'chkin_by_course'
      end
	  end	  
    #@students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE course_status_id ='1' AND date_start = '#{date_start}' order by date_start ASC")
    #@students = CourseImplementation.find_by_sql("select * from vw_detailed_courses WHERE date_start = '#{date_start}' order by date_start ASC")
    render layout: 'standard-layout'
	end

  def find_to_checkin
    today = Time.new
    @day, @month, @year = today.day, today.month, today.year
    tomorrow = today - (60 * 60 * 24 * 1)
	  oneweekago     = today - (7 * (60 * 60 * 24))
	  threedayslater = today + (3 * (60 * 60 * 24))

    @day_next, @month_next, @year_next = tomorrow.day, tomorrow.month, tomorrow.year
    @day_week, @month_week, @year_week = oneweekago.day, oneweekago.month, oneweekago.year
    @day_three, @month_three, @year_three = threedayslater.day, threedayslater.month, threedayslater.year
      
    date_start_week = "#{@month_week}/#{@day_week}/#{@year_week}" if !params[:report1]
    date_end_three = "#{@month_three}/#{@day_three}/#{@year_three}" if !params[:report1]

    sql = "SELECT v.id,v.name as course_name,code,p.id as profile_id,p.name,p.ic_number,student_status_id,ca.id as student_id FROM vw_detailed_courses v
	          INNER JOIN course_applications ca ON ca.course_implementation_id=v.id
			  INNER JOIN profiles p ON p.id=ca.profile_id
			  WHERE (date_start BETWEEN '#{date_start_week}' AND '#{date_end_three}' AND date_end>='#{today}' OR date_start<='#{today}' AND date_end>='#{today}')
			   AND student_status_id in(4,5,6,8,9)
			   AND p.name ilike '%#{params[:name]}%'
    "
    @students = CourseApplication.find_by_sql(sql)
    render layout: 'standard-layout'
  end
  	

  def cetak_list_trainer_checkin
  	course_sankasha_ichiran
  end

  def cetak_list_checkin
  	course_sankasha_ichiran
  end
  
  def list_belum_checkin
  	course_sankasha_ichiran
  end

  def list_sudah_checkin
  	course_sankasha_ichiran
  end
  
  def course_trainer_list
    @course_implementation = CourseImplementation.find(params[:id])
    render :layout => "standard-layout"
  end
  
  def course_sankasha_ichiran
    @course_implementation = CourseImplementation.find(params[:id])

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]
	  
      @students = CourseApplication.find_by_sql("SELECT ca.* FROM course_applications ca,profiles p WHERE p.id=ca.profile_id AND
	          course_implementation_id=#{@course_implementation.id} 
			  AND student_status_id in(4,5,6,8,9) ORDER BY name")
    else
      @students = []
    end
    render :layout => "standard-layout"
  end

  def list_penghuni
    @course_implementation = CourseImplementation.find(params[:id])

    if @course_implementation

      params[:orderby] = "personal_name" if !params[:orderby]
      @orderby = params[:orderby]
      params[:arrow] = "ASC" if !params[:arrow]
      @arrow = params[:arrow]
	  
      @students = CourseApplication.find_by_sql("SELECT ca.* FROM course_applications ca,profiles p,vw_detail_penghuni_asrama h 
	          WHERE p.id=ca.profile_id AND
	          course_implementation_id=#{@course_implementation.id} 
			  AND h.profile_id=p.id
			  AND student_status_id in(4,5,6,8,9) ORDER BY h.name")
    else
      @students = []
    end
  end

  def trainer_chkin
    @trainer = Trainer.find(params[:id])
    @profile = @trainer.profile
    @employment = @profile.employments.first
    @course_implementation = CourseImplementation.find(params[:cimp_id])

    if !params['block_id']
      @blocks = HostelBlock.find(:all, :conditions=>"gender=#{@trainer.profile.gender_id}")
      #render :text=> @blocks.size
      @hostel_block = @blocks.first
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
	
  	already_chkin = Hostel.find_by_sql("select * from hostel_penghuni where profile_id=#{@profile.id}") 
    if already_chkin.size > 0
      r = Hostel.find(already_chkin.first.hostel_id)
      redirect_to("/hostels/showchkin_trainer/#{@trainer.id}?block_id=#{r.block_id}") and return
    end
  end

  def trainer_chkin_save
    @trainer = Trainer.find(params[:id])
    @profile = @trainer.profile
    @employment = @profile.employments.first
    @course_implementation = CourseImplementation.find(params[:course_implementation_id])

    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id,no_tel,no_kenderaan,no_kunci,category,course_implementation_id,expected_date_out)
	        VALUES(#{@room.id},#{@profile.id},'#{params[:no_tel]}', '#{params[:no_kenderaan]}', '#{params[:no_kunci]}',2, #{params[:course_implementation_id]}, '#{@course_implementation.date_end}')"
    @h = Hostel.find_by_sql(sql)
	
    #render :text=> sql and return;
	
    today = Time.new
    @hstl_prfl = HostelProfile.new(:hostel_id => @room.id,
      :profile_id => @profile.id,
      :no_kenderaan => "#{params[:no_tel]}",
      :no_kenderaan => "#{params[:no_kenderaan]}",
      :no_kunci => "#{params[:no_kunci]}",
      :course_implementation_id => "#{params[:course_implementation_id]}",
      :date_in => today,
      :expected_date_out => @course_implementation.date_end)
    @hstl_prfl.save
		
    redirect_to("/hostels/showchkin_trainer/#{@trainer.id}?block_id=#{params[:block_id]}")
  end

  def iwannachkin
    @student = CourseApplication.find(params[:id])
    @profile = @student.profile
    @employment = @profile.employments.first

    if !params['block_id']
      @blocks = HostelBlock.find(:all, :conditions=>"gender=#{@student.profile.gender_id}")
      #render :text=> @blocks.size
      @hostel_block = @blocks.first
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
	
  	already_chkin = Hostel.find_by_sql("select * from hostel_penghuni where profile_id=#{@profile.id}") 
    if already_chkin.size > 0
      r = Hostel.find(already_chkin.first.hostel_id)
      redirect_to("/hostels/#{@student.id}/showchkin?block_id=#{r.block_id}") and return
    else
      render :layout => "standard-layout"
    end

  end

  def ivedonechkin
    @student = CourseApplication.find(params[:id])
    @profile = @student.profile
    @employment = @profile.employments.first
    @course_implementation = @student.course_implementation

    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    t1 = Time.now
    time_now = t1.to_formatted_s(:my_format_y) + "-" + t1.to_formatted_s(:my_format_m) + "-" + t1.to_formatted_s(:my_format_d)
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id,no_tel,no_kenderaan,no_kunci,course_implementation_id,expected_date_out,created_at)
	        VALUES(#{@room.id},#{@profile.id},'#{params[:no_tel]}', '#{params[:no_kenderaan]}', '#{params[:no_kunci]}', #{@course_implementation.id},'#{@course_implementation.date_end}', current_timestamp)"
	
	
    @h = Hostel.find_by_sql(sql)
	
    #render :text=> sql and return;
	
    @student.update_attributes(:hostel_id => @room.id)
	
    today = Time.new
    @hstl_prfl = HostelProfile.new(:hostel_id => @room.id,
      :profile_id => @profile.id,
      :date_in => today,
      :expected_date_out => @student.course_implementation.date_end)
    @hstl_prfl.save
		
    redirect_to("/hostels/showchkin/#{@student.id}?block_id=#{params[:block_id]}")
  end

  def change_room
  	if params[:profile_id]
      sql = "DELETE from hostel_penghuni where profile_id=#{params[:profile_id]}"
      @h = Hostel.find_by_sql(sql)
    elsif params[:id]
			@student = CourseApplication.find(params[:id])
			sql = "DELETE from hostel_penghuni where profile_id=#{@student.profile_id}"
			@h = Hostel.find_by_sql(sql)
		  
    else
      sql = "i donno wattodo"
    end

    @student = CourseApplication.find(params[:id])
    @profile = @student.profile
    @employment = @profile.employments.first
    @course_implementation = @student.course_implementation
	
    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id,no_tel,no_kenderaan,no_kunci,course_implementation_id,expected_date_out)
	        VALUES(#{@room.id},#{@profile.id},'#{params[:no_tel]}', '#{params[:no_kenderaan]}', '#{params[:no_kunci]}', #{@course_implementation.id}, '#{@course_implementation.date_end}')"
    @h = Hostel.find_by_sql(sql)
	
    @student.update_attributes(:hostel_id => @room.id)
	
    @hstl_prfl = HostelProfile.find(:first,:conditions=>"profile_id=#{@profile.id}", :order=>"created_on desc")
    if @hstl_prfl
      @hstl_prfl.update_attributes(:hostel_id=>@room.id)
    end
		
    redirect_to("/hostels/showchkin/#{@student.id}?block_id=#{params[:block_id]}")
  end

  def change_room_trainer
  	if params[:profile_id]
	  	@hpenghuni = HostelPenghuni.find_by_profile_id(params[:profile_id])
      @course_implementation = CourseImplementation.find(@hpenghuni.course_implementation_id)
      sql = "DELETE from hostel_penghuni where profile_id=#{params[:profile_id]}"
      @h = Hostel.find_by_sql(sql)
    elsif params[:id]
			@trainer = Trainer.find(params[:id])
			sql = "DELETE from hostel_penghuni where profile_id=#{@trainer.profile_id}"
			@h = Hostel.find_by_sql(sql)
		  
    else
      sql = "i donno wattodo"
    end

    @trainer = Trainer.find(params[:id])
    @profile = @trainer.profile
    @employment = @profile.employments.first
	
    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id,no_tel,no_kenderaan,no_kunci,category,course_implementation_id,expected_date_out)
	        VALUES(#{@room.id},#{@profile.id},'#{params[:no_tel]}', '#{params[:no_kenderaan]}', '#{params[:no_kunci]}',2, #{@course_implementation.id}, '#{@course_implementation.date_end}')"
    @h = Hostel.find_by_sql(sql)
		
    @hstl_prfl = HostelProfile.find(:first,:conditions=>"profile_id=#{@profile.id}", :order=>"created_on desc")
    if @hstl_prfl
      @hstl_prfl.update_attributes(:hostel_id=>@room.id)
    end
		
    redirect_to("/hostels/showchkin_trainer/#{@trainer.id}?block_id=#{params[:block_id]}")
  end
  
  def showchkin
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
	
    @student = CourseApplication.find(params[:id])
    @profile = @student.profile
    @employment = @profile.employments.first
  end

  def showchkin_trainer
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
	
    @trainer = Trainer.find(params[:id])
    @profile = @trainer.profile
    @employment = @profile.employments.first
    @hpenghuni = HostelPenghuni.find_by_profile_id(@profile.id)
    @course_implementation = CourseImplementation.find(@hpenghuni.course_implementation_id)
	
  end

  def find_guest
  
  end
  
  def find_guest_result
  	@ls = []
  	if params[:search] == "name"
      sql = "SELECT * FROM vw_detail_penghuni_asrama WHERE name ilike '%#{params[:name]}%'"
      @ls = Hostel.find_by_sql(sql)
      @ls = Hostel.find_by_sql(sql) if params[:name] != ""
    elsif params[:search] == "nokp"
      sql = "SELECT * FROM vw_detail_penghuni_asrama WHERE ic_number ilike '%#{params[:nokp]}%'"
      @ls = Hostel.find_by_sql(sql) if params[:nokp] != nil
    else
      @ls = []
    end
  end

  def rekod_guna_bilik
  	#$_ = "select hp.*,p.name,p.ic_number,p.opis from hostel_profiles hp,profiles p WHERE p.id=hp.profile_id"
  	$_ = "select hp.*,p.name,p.ic_number,p.opis, hb.description as block_desc,h.level,h.room
	      FROM hostel_profiles hp
	      INNER JOIN profiles p ON p.id=hp.profile_id
		  INNER JOIN hostels h ON h.id=hp.hostel_id
		  INNER JOIN hostel_blocks hb ON hb.id=h.block_id
    "
    @ls = CourseApplication.find_by_sql($_)
    render layout: "standard-layout"
  end
  
  def cetak_find_checkout
    prepare_find_checkout
    render layout: "standard-layout"
  end
  def find_checkout
    prepare_find_checkout
    render layout: "standard-layout"
  end

  def iwannachkout
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
	
    @profile = Profile.find(params[:id])
    @employment = @profile.employments.first
  end

  def ivedonechkout
    @profile = Profile.find(params[:id])
    room_id = Hostel.find_by_sql("select * from hostel_penghuni where profile_id=#{@profile.id}")
    @room = Hostel.find(room_id.first.hostel_id)
    sql = "DELETE FROM hostel_penghuni where profile_id=#{params[:id]}"
    @h = Hostel.find_by_sql(sql)
	
    @hstl_prfl = HostelProfile.find(:first,:conditions=>"profile_id=#{@profile.id}", :order=>"created_on desc")
    if @hstl_prfl
      @hstl_prfl.update_attributes(:date_out=>Time.new, :is_key_returned=>"params[:is_key_returned]")
    end
	
    flash[:notice] = "#{nof{@profile.title.description.upcase}} #{@profile.name.upcase} telah berjaya check-out dari bilik #{@room.block.description}-#{@room.level}-#{@room.room}."
    redirect_to("/hostels/list?block_id=#{@room.block_id}")
  end


  #untuk sewaan asrama

  def new_penghuni
    @profile = Profile.new
    render :layout => "standard-layout"
  end

  def new_but_penghuni_already_exist
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    
  end

  def create_penghuni
    @profile = Profile.new(params[:profile])
	
    if @profile.save
      flash[:notice] = 'Maklumat berjaya disimpan.'
      redirect_to iwannarent_hostel_path(@profile.id)
    else
      @profile.destroy
      render :action => 'new_penghuni', :layout => "standard-layout"
    end
  end

  def create_but_staff_already_exist
    @profile = Profile.find_by_ic_number(params[:profile][:ic_number])
    if @profile.save
      flash[:notice] = 'Maklumat Penyewa Berjaya Disimpan'
      redirect_to :action => 'iwannarent', :id=>@profile.id #tujuan dia utk bawak id tu
    else
      render :action => 'new_but_penghuni_already_exist'
    end  
  end
  

  def iwannarent
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end

    @profile = Profile.find(params[:id])
    render :layout => "standard-layout"
  end

  def iverent

	
    @profile = Profile.find(params[:id])
    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id) VALUES(#{@room.id},#{@profile.id})"
    @h = Hostel.find_by_sql(sql)
	
    #@student.update_attributes(:hostel_id => @room.id)
	
    today = Time.new
    @hstl_prfl = HostelProfile.new(:hostel_id => @room.id,
      :profile_id => @profile.id,
      :date_in => today)
    @hstl_prfl.save
		
    redirect_to("/hostels/#{@profile.id}/showrent?block_id=#{params[:block_id]}")
 
  end

  
  def showrent
    @profile = Profile.find(params[:id])
    if !params['block_id']
      @hostel_block = HostelBlock.find(:first, :order=>"description")
    else
      @hostel_block = HostelBlock.find(params[:block_id])
    end
    render :layout => "standard-layout"
  end

  def change_room_rent
  	if params[:profile_id]
      sql = "DELETE from hostel_penghuni where profile_id=#{params[:profile_id]}"
      @h = Hostel.find_by_sql(sql)
    elsif params[:id]
			@profile = Profile.find(params[:id])
			sql = "DELETE from hostel_penghuni where profile_id=#{@student.profile_id}"
			@h = Hostel.find_by_sql(sql)
		  
    else
      sql = "i donno wattodo"
    end


    @profile = Profile.find(params[:id])
	
    @room = Hostel.find_by_sql("select * from hostels where block_id=#{params[:block_id]} and level=#{params[:level]} and room=#{params[:room]}")
    @room = @room.first
    sql = "INSERT INTO hostel_penghuni(hostel_id,profile_id) VALUES(#{@room.id},#{@profile.id})"
    @h = Hostel.find_by_sql(sql)
	
    #@student.update_attributes(:hostel_id => @room.id)
	
    @hstl_prfl = HostelProfile.find(:first,:conditions=>"profile_id=#{@profile.id}", :order=>"created_on desc")
    if @hstl_prfl
      @hstl_prfl.update_attributes(:hostel_id=>@room.id)
    end
		
    redirect_to("/hostels/#{@profile.id}/showrent?block_id=#{params[:block_id]}")
  end

  private
  #endof sewaan asrama
  def prepare_find_checkout
  	unless params[:to_checkout_room].blank?
      r=params[:to_checkout_room].split("-")
      if r.size==3
        w="where block_desc='#{r[0]}' and level='#{r[1]}' and room='#{r[2]}'"
      end
    end
  	unless params[:to_checkout_name].blank?
      w="where name ilike '%#{params[:to_checkout_name]}%'"
    end
  	unless params[:to_checkout_nokp].blank?
      w="where ic_number ilike '%#{params[:to_checkout_nokp]}%'"
    end

    t = Time.now
    y = t.strftime("%Y")
    m = t.strftime("%m")
    d = t.strftime("%d")
    ymd = "#{y}-#{m}-#{d}"

    unless w.blank?
      $_ = "select * from vw_detail_penghuni_asrama #{w}"
    else
      $_ = "select * from vw_detail_penghuni_asrama where expected_date_out<'#{ymd}'"
    end
  	unless params[:to_checkout_kodkursus].blank?

	  	$_ = "select vhp.*,ci.code from vw_detail_penghuni_asrama vhp INNER JOIN course_implementations ci ON ci.id=vhp.course_implementation_id
		      where ci.code = '#{params[:to_checkout_kodkursus]}'"
    end

    @ls = CourseApplication.find_by_sql($_)
  end
end
