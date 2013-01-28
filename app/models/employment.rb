# -*- encoding : utf-8 -*-
class Employment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :job_profile
  belongs_to :place
end
