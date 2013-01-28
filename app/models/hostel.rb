# -*- encoding : utf-8 -*-
class Hostel < ActiveRecord::Base
	belongs_to :block,
			   :class_name  => "HostelBlock",
			   :foreign_key => "block_id"

	belongs_to :hostel_status
	belongs_to :hostel_type
	belongs_to :gender

	has_and_belongs_to_many :hostel_fixtures,
							:class_name  => "HostelFixture",
	                        :join_table  => "fixture_n_fittings",
							:foreign_key => "hostel_id",
							:association_foreign_key => "hostel_fixture_id"

	has_and_belongs_to_many :sejumlah_penghuni,
	                        :class_name => "Profile",
	                        :join_table  => "hostel_penghuni",
							:foreign_key => "hostel_id",
							:association_foreign_key => "profile_id"
end
