# -*- encoding : utf-8 -*-
class HostelReservation < ActiveRecord::Base
    has_many :profiles
    has_many :hostel_types
    
    validates_presence_of :profile_id, :total_room, :chkin_date, :chkout_date, :hostel_type_id,
                          :message => ": masukkan nilai."

	#type
	validates_numericality_of :total_room,
  							  :message => ": hanya mempunyai nombor sahaja."
    
    def validate
      if (chkout_date != nil && chkin_date != nil)
      if chkout_date < chkin_date
  	    errors.add_to_base("Tarikh keluar mesti lebih dari tarikh daftar")
  	  end
  	  end
    end
end
