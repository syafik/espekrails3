# -*- encoding : utf-8 -*-
class SesiHarian < ActiveRecord::Base
  set_table_name 'sesi_harian'
  belongs_to :course_implementation
  belongs_to :session_code
end
