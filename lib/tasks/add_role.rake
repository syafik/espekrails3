# Create new role for pengajar
task :create_role_pengajar => :environment do
  ActiveRecord::Base.transaction do
    new_role_name = 'Pengajar'
    new_role_description = 'Pengajar Kursus'
    
    new_role = Role.new({:name => new_role_name, :description => new_role_description, :omnipotent => false, :system_role => true})
    if new_role.save!
      puts "New Role Name = #{new_role.name}, ID = #{new_role.id}"
      admin = User.find_by_login('admin')
      user_roles = User.find_by_sql("insert into roles_users(user_id,role_id) values(#{admin.id}, #{new_role.id})")
      puts "Admin is now #{new_role.name}"
    else
      puts "Create new Role - #{new_role_name} - Failed !!"
    end
  end # transaction
end