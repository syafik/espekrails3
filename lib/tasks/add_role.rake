task :create_admin_roles => :environment do
  desc "Create new roles : Pengajar, Kewangan and add the roles to user Admin"

  new_role_name_pengajar = "Pengajar"
  new_role_pengajar_description = "Tenaga Pengajar"
  new_role_name_kewangan = "Kewangan"
  new_role_kewangan_description = "Pegawai Kewangan"
  new_role_name_eksekutif = "Eksekutif"
  new_role_eksekutif_description = "Pegawai Eksekutif"

 ActiveRecord::Base.transaction do
   create_role(new_role_name_pengajar, new_role_pengajar_description)
   create_role(new_role_name_kewangan, new_role_kewangan_description)
   create_role(new_role_name_eksekutif, new_role_eksekutif_description)   
 end # transaction
  
end #task create_roles

def my_test
  puts "Something"
end

def create_role(name, description)
  if is_role_exist?(name)
    puts "Role #{name} is already exist. Skipping creation"
  else
    new_role = insert_new_role(name, description)
    
    if new_role.blank?
      raise "Error inserting Role #{name} to DB"
    else
      add_admin_role(new_role)
    end
  end #is_role_exists?     
end

def is_role_exist?(role_name)
  Role.find_by_name(role_name).blank? ? false : true
end

def insert_new_role(name, description)
  new_role = Role.new({:name => name, :description => description, :omnipotent => false, :system_role => true})
  if new_role.save!
    return new_role
  else
    return nil
  end
end

def add_admin_role(role)
  admin = User.find_by_login('admin')
  if admin.blank?
    puts "Can't find user Admin"
    return
  end
  user_roles = User.find_by_sql("insert into roles_users(user_id,role_id) values(#{admin.id}, #{role.id})")
  puts "Admin is now #{role.name}"
end

task :create_trainer_account_example => :environment do
  #ActiveRecord::Base.transaction do
  password = 'katasandi'
  kp = "888123888"
  name2 = "pengajar contoh"
  email = "jojon.dudu@gmail.com"
  dp2 = "department contoh"
  phone = "23456789"
  profile_id = '5312'
  user = User.new(:ic_number => kp, :name => name2, :email => email, :department => dp2, :phone =>phone, :password => password, :password_confirmation => password)
  #User.transaction(@user) do
  user.new_password = true
  user.verified = 1
  if user.valid?
    z = User.find_by_email(email)
    if z.present?
      z.destroy
    end
    a = User.find_by_sql("insert into users(ic_number,verified,profile_id,name,email,department,phone,security_token,salt,salted_password,created_at) values('#{kp}','1','#{profile_id}','#{name2}','#{email}','#{dp2}','#{phone}','#{user.security_token}','#{user.salt}','#{user.salted_password}','#{Time.now}')")
    b = User.find_by_ic_number(kp)
    c = Role.find_by_sql("insert into roles_users(user_id,role_id) values('#{b.id}','11')")
    
    #s = AuthenticatedUser.hashed("salt-#{Time.now}")
    #sp = AuthenticatedUser.salted_password(s, AuthenticatedUser.hashed("#{password}"))
    #key = AuthenticatedUser.hashed(sp + Time.now.to_i.to_s + rand.to_s)
    #a = User.find_by_sql("insert into users(ic_number,verified,name,email,department,phone,security_token,salt,salted_password,created_at,profile_id) values('#{kp}','1','#{name2}','#{email}','#{dp2}','#{phone}','#{key}','#{s}','#{sp}','#{Time.now}',#{683})")
  end
  # end
  if b.profile.trainer.update_attribute(:fasilitator_rate, 1000)
    course_implementations_trainers = User.find_by_sql("update course_implementations_trainers  set category_trainer_id = 2 where trainer_id = 134 and course_implementation_id=1088")
    b.profile.update_attributes(:bank_account_name => "MAYBANK/JALAN IPOH KUALA LUMPUR" ,:bank_account_number => "5628456374623")
#    employment = Employment.find_by_profile_id(15577)
#    if employment.present?
#      employment.update_attribute(:profile_id, 683)
#      puts "employment updated"
#    end
  puts "sample trainer account created with ic_number = '#{kp}', and password='#{password}'"
  end
end