# -*- encoding : utf-8 -*-
class FixtureFitting < ActiveRecord::Base
	set_table_name 'fixture_n_fittings'
	belongs_to :hostel
	belongs_to :hostel_fixture
end
