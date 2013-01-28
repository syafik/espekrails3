# -*- encoding : utf-8 -*-
class HostelPenghuni < ActiveRecord::Base
  set_table_name "hostel_penghuni"
  belongs_to :profile
  belongs_to :hostel
end
