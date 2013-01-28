# -*- encoding : utf-8 -*-
class TempahanSijil < ActiveRecord::Base
  belongs_to :course_implementation
  
  set_table_name "tempahan_sijil"
end
