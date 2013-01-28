# -*- encoding : utf-8 -*-
module MenuHelper
def user
  @profiles = Profile.find(session[:user].profile_id)
end
end
