# -*- encoding : utf-8 -*-
class CertPolicy < ActiveRecord::Base
  belongs_to :course_implementation
  
  set_table_name "cert_policy"
end
