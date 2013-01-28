# -*- encoding : utf-8 -*-
class StatusPerlaksanaan < ActiveRecord::Base
  belongs_to :course_implementation
  set_table_name "status_perlaksanaan"
end
