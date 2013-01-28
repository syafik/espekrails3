# -*- encoding : utf-8 -*-
class FacilityReservation < ActiveRecord::Base
    #has_many :profiles
    #has_many :facilities
    belongs_to :profile
    belongs_to :facility
    belongs_to :course_implementation
    validates_presence_of :profile_id, :facility_id, :date_from, :date_to,
                          :message => ": masukkan nilai."

	

end
