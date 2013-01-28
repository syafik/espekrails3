# -*- encoding : utf-8 -*-
class ParticipantEvaluation < ActiveRecord::Base
  belongs_to :course_implementation
  belongs_to :course_application
end
