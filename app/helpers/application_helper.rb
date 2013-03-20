# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include LoginEngine
  include UserEngine
	def nof
		begin
			return yield
		rescue
			return nil
		end
	end

	def nl2br(string)
    string.gsub("\n", '<br/>').gsub("<?", '&lt;?')
	end

	def list_border
		"border=\"0\""
	end

	def list_bgcolor
		"#777777"
	end

	def list_cellspacing
		"0"
	end

	def list_cellpadding
		"2"
	end

	def list_font_size
		"style=\"font-size: 10.5px\""
	end
	
	def dmy(ymd_date, separator, new_separator)
		a = ymd_date.to_s.split(separator)
		b = "#{a[2]}#{new_separator}#{a[1]}#{new_separator}#{a[0]}"
		return b
	end
	
	def f2( f )
		return format("%0.1f", f).to_f
	end

  def f1( f )
    return format("%0.2f", f).to_f
  end

	def d4( d )
		return format("%04d", d)
	end

	def getAttPercent(student_id)
		@student = CourseApplication.find(student_id)
		@att = Attendance.find_all_by_course_application_id(student_id)
		jumlah_hadir = @att.size
		return 0 if jumlah_hadir == 0
		patut_hadir = @student.course_implementation.sesi_harian.size
		if patut_hadir != 0
			a = (jumlah_hadir.to_f / patut_hadir.to_f) * 100
		else
			a = 0
		end
		percent = a.floor
		return percent 
	end
	
	def save_audit(rail_controller, rail_action, modul, submodul, action_type, login)
		@at = AuditTrail.new
		@at.action_type = action_type
		@at.modul = modul
		@at.submodul = submodul
		@at.rail_controller = rail_controller
		@at.rail_action = rail_action
		@at.login = login
	end
	
	def getNoSijilTerkini(dept_id) 
		sql = "SELECT no_sijil FROM vw_detailed_peserta WHERE course_department_id=#{dept_id} AND no_sijil!='' ORDER BY no_sijil DESC LIMIT 1"
		a = CourseApplication.find_by_sql(sql)
		if a.size > 0
			a[0].no_sijil
		else
			"0000"
		end
	end
  def show_error_messages(content)
    ret = ''
    if content.errors.any?
      ret +='<ul>'
      content.errors.full_messages.each do |msg|
        ret += "<li>#{ msg }</li>"
      end
      ret += "</ul>"
    end
    ret.html_safe
  end
end

