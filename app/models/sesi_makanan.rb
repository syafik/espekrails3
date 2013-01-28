# -*- encoding : utf-8 -*-
class SesiMakanan < ActiveRecord::Base
  set_table_name 'sesi_makanan'
  belongs_to :course_implementation
end
