# -*- encoding : utf-8 -*-
class SuratLantikContent < ActiveRecord::Base
	set_table_name "surat_lantik_content"
    belongs_to :course_department
    belongs_to :course_implementation
end
