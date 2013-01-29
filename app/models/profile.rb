# -*- encoding : utf-8 -*-
class Profile < ActiveRecord::Base
  belongs_to :state
  belongs_to :religion
  belongs_to :race
  belongs_to :title
  belongs_to :marital_status
  belongs_to :gender
  belongs_to :place
  belongs_to :handicap
  belongs_to :course_department

  has_many :relatives
  has_many :employments
  has_many :qualifications
  has_many :expertises
  has_many :trainings
  
  has_one :staff
  has_one :trainer
  has_one :user

  has_many :course_applications, :order=> "id desc"
  has_many :completed_course_applications,
           :class_name=> "CourseApplication",
           :conditions=> "student_status_id = 5 OR student_status_id = 8"
  has_many :course_evaluations

  has_many :dipilih,
           :class_name=> "CourseApplication",
           :conditions=> "student_status_id NOT IN(1,3,12)"

  has_many :hadir,
           :class_name=> "CourseApplication",
           :conditions=> "student_status_id IN(5,8)"

  has_one  :hostel_penghuni,
           :class_name=> "HostelPenghuni"
  
  #has_and_belongs_to_many :roles
  validates_uniqueness_of :ic_number, :on => :create
  validates_presence_of :name, :ic_number, :race, :gender,
                        :religion
#  file_column :image, :store_dir => "/aplikasi/www/instun/public/profile/image",
#              :magick => {:crop => "1:1", :geometry => "156x156>"}
  #validates_filesize_of :image, :in => 0.kilobytes..200.kilobytes
  #validates_format_of :image, :with => %r{.(gif|jpg|png)$}i
  #validates_file_format_of :image, :in => ["image/jpeg"]
   
end
