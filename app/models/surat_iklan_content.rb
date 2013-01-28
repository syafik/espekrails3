# -*- encoding : utf-8 -*-
class SuratIklanContent < ActiveRecord::Base
	set_table_name "surat_iklan_content"
    belongs_to :course_department
    belongs_to :course_implementation
end
