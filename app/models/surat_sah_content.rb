# -*- encoding : utf-8 -*-
class SuratSahContent < ActiveRecord::Base
    set_table_name "surat_sah_content"
    belongs_to :course_department
    belongs_to :course_implementation
end
