# -*- encoding : utf-8 -*-
# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'login_engine'
require 'user_engine'
#require 'custom_error_message'

class ApplicationController < ActionController::Base
#  protect_from_forgery
  include LoginEngine
  include UserEngine
  
#  helper :user
#  model :user

  before_filter :authorize_action, :except => [:success]

end

def test_date(course_implementation,start,_day, start_month, start_year)
  Date.valid_civil?(params[course_implementation][:start_year].to_i,
    params[course_implementation][:start_month].to_i,
    params[course_implementation][:start_day].to_i)
end

def valid
  test_date(:course_implementation,'date_plan_start')
end

def test_datet(course_implementation,end_day, end_month, end_year)
  Date.valid_civil?(params[course_implementation][:end_year].to_i,
    params[course_implementation][:end_month].to_i,
    params[course_implementation][:end_day].to_i)
end

def valide
  test_datet(:course_implementation,'date_plan_end')
end

def validate

  if date_plan_end < date_plan_start
    errors.add_to_base("Tarikh akhir mesti lebih dari tarikh mula")
  end
end

##added 11/03/2006 -sham-
$MONTH_NAMES = %w{ Januari Februari Mac April Mei Jun Julai Ogos September Oktober November Disember }
$SHORT_MONTH_NAMES = %w{ Jan Feb Mac Apr Mei Jun Jul Ogos Sept Okt Nov Dis }

def msian_date_formal(date)
  date.to_formatted_s(:my_format_day) + " " +
		$SHORT_MONTH_NAMES[date.to_formatted_s(:my_format_month).to_i - 1] + ", " +
		date.to_formatted_s(:my_format_year)
end

def msian_date_very_formal(date)
  date.to_formatted_s(:my_format_day) + " " +
		$MONTH_NAMES[date.to_formatted_s(:my_format_month).to_i - 1] + ", " +
		date.to_formatted_s(:my_format_year)
end

def msian_date_very_formal_2(date)
  date.to_formatted_s(:my_format_day) + " " +
		$MONTH_NAMES[date.to_formatted_s(:my_format_month).to_i - 1] + " " +
		date.to_formatted_s(:my_format_year)
end

def msian_date_with_slash(date)
  date.to_formatted_s(:my_format_day) + "/" +
		date.to_formatted_s(:my_format_month) + "/" +
		date.to_formatted_s(:my_format_year)
end
##EOadded 11/03/2006 -sham-

def nof
  begin
    return yield
  rescue
    return nil
  end
end

def welcometoinstun
  700000000000
end
