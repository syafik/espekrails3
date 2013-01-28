# -*- encoding : utf-8 -*-
class SuratTawaranContent < ActiveRecord::Base
	set_table_name "surat_tawaran_content"
    belongs_to :course_department
    belongs_to :course_implementation
end
