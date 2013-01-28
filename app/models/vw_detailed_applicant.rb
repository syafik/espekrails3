# -*- encoding : utf-8 -*-
class VwDetailedApplicant < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_implementation
end

