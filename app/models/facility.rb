# -*- encoding : utf-8 -*-
class Facility < ActiveRecord::Base
  belongs_to :facility_type
  belongs_to :facility_category
  belongs_to :facility_status
  
  validates_presence_of :price
  
  validates_numericality_of :capacity, :price,
  							:message => ": hanya mempunyai nombor sahaja."
end
