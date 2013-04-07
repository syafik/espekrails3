class Notification < ActiveRecord::Base
  set_primary_key :id
  belongs_to :course_implementation
  belongs_to :course
  belongs_to :course_location
  belongs_to :profile
  belongs_to :user
end
