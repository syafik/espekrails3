# -*- encoding : utf-8 -*-
class UserNotify < ActionMailer::Base
  def signup(user, password, url=nil)
    setup_email(user)

    # Email header info
    @subject += "Permohonan Akaun"

    # Email body substitutions
    @name = "#{user.firstname} #{user.lastname}"
    @login = user.login
    @ic_number = user.ic_number
    @password = password
    @url = url || LoginEngine.config(:app_url).to_s
    @app_name = LoginEngine.config(:app_name).to_s

    mail(
      :from => LoginEngine.config(:email_from).to_s,
      :to => user.email,
      :bcc => ["espek@instun.gov.my", "adila@instun.gov.my", "whashim@gmail.com"],
      :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
      :subject => "[#{LoginEngine.config(:app_name)}] Permohonan Akaun ")
    
  end

  def approve(user, url=nil)
    setup_email(user)

    # Email header info
    @subject += "Permohonan Akaun"

    # Email body substitutions
    @body["name"] = user.name
    @body["login"] = user.login
    @body["ic_number"] = user.ic_number
    @body["url"] = url || LoginEngine.config(:app_url).to_s
    @body["app_name"] = LoginEngine.config(:app_name).to_s
  end

  def forgot_password(user, url=nil)
    #@recipients = "#{user.profile.email}"
    #@from       = LoginEngine.config(:email_from).to_s
    #@subject    = "[#{LoginEngine.config(:app_name)}] "
    #@sent_on    = Time.now
    #@headers["bcc"]      = "syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
    #@headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
    #
    ##setup_email(user)
    #@headers["cc"]      = nof{user.email}
    ## Email header info
    #@subject += "Pemberitahuan 'Lupa Kata Laluan'"
    #
    ## Email body substitutions
    #@body["name"] = nof{user.profile.name}
    #@body["title"] = nof{user.profile.title.description}
    #@body["login"] = user.login
    #@body["ic_number"] = user.ic_number
    #@body["url"] = url || LoginEngine.config(:app_url).to_s
    #@body["app_name"] = LoginEngine.config(:app_name).to_s

    setup_email(user)

    # Email header info
    @subject += "Permohonan Akaun"

    # Email body substitutions
    @name = "#{user.firstname} #{user.lastname}"
    @login = user.login
    @ic_number = user.ic_number
    @url = url || LoginEngine.config(:app_url).to_s
    @app_name = LoginEngine.config(:app_name).to_s

    mail(
        :from => LoginEngine.config(:email_from).to_s,
        :to => user.email,
        :bcc => ["espek@instun.gov.my", "adila@instun.gov.my", "whashim@gmail.com"],
        :content_type => "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed",
        :subject => "[#{LoginEngine.config(:app_name)}] Pemberitahuan 'Lupa Kata Laluan' ")
  end

  def change_password(user, password, url=nil)
    setup_email(user)
    @headers["bcc"]      = "syedmohd@gmail.com,mhafizm@gmail.com"
    @headers["cc"]      = nof{user.profile.email}
    # Email header info
    @subject += "Pemberitahuan 'Tukar Kata Laluan'"

    # Email body substitutions
    @body["name"] = nof{user.profile.name}
    @body["title"] = nof{user.profile.title.description}
    @body["login"] = user.login
    @body["ic_number"] = user.ic_number
    @body["password"] = password
    @body["url"] = url || LoginEngine.config(:app_url).to_s
    @body["app_name"] = LoginEngine.config(:app_name).to_s
  end

  def pending_delete(user, url=nil)
    setup_email(user)

    # Email header info
    @subject += "Delete user notification"

    # Email body substitutions
    @body["name"] = "#{user.firstname} #{user.lastname}"
    @body["url"] = url || LoginEngine.config(:app_url).to_s
    @body["app_name"] = LoginEngine.config(:app_name).to_s
    @body["days"] = LoginEngine.config(:delayed_delete_days).to_s
  end

  def delete(user, url=nil)
    setup_email(user)

    # Email header info
    @subject += "Delete user notification"

    # Email body substitutions
    @body["name"] = "#{user.firstname} #{user.lastname}"
    @body["url"] = url || LoginEngine.config(:app_url).to_s
    @body["app_name"] = LoginEngine.config(:app_name).to_s
  end

  def setup_email(user)
    @recipients = "#{user.email}"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "[#{LoginEngine.config(:app_name)}] "
    @sent_on    = Time.now
#    @headers["bcc"]      = "espek@instun.gov.my, adila@instun.gov.my" #syedmohd@gmail.com,espek@instun.gov.my,mhafizm@gmail.com"
#    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"
  end

  def sample
    @recipients = "sham@orenda.com.my,mhafizm@orenda.com.my"
    @from       = LoginEngine.config(:email_from).to_s
    @subject    = "Siapa nak makan nasi ayam "
    @sent_on    = Time.now
    @headers["bcc"]      = "syedmohd@gmail.com"
    @headers['Content-Type'] = "text/plain; charset=#{LoginEngine.config(:mail_charset)}; format=flowed"

#    @body["name"] = "#{user.firstname} #{user.lastname}"
#    @body["url"] = url || LoginEngine.config(:app_url).to_s
#    @body["app_name"] = LoginEngine.config(:app_name).to_s

  end
end
