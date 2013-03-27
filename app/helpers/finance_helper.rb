# -*- encoding : utf-8 -*-
module FinanceHelper

  def get_course_info(timetable_id)
    timetable = Timetable.find(timetable_id)
    if timetable.present?
      return raw ("Tarikh:#{timetable.date.to_formatted_s(:my_format_4)}<br/>Kursus: #{timetable.course_implementation.course.name}<br/>Slot: #{timetable.topic}")
    else
      return "-"
    end
  end

end
