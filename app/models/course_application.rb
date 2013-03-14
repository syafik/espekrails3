# -*- encoding : utf-8 -*-
require_dependency "search"
class CourseApplication < ActiveRecord::Base
  searches_on :name
  
  belongs_to :profile
  belongs_to :course_implementation
  belongs_to :course
  belongs_to :approval
  belongs_to :student_status
  belongs_to :hostel
  has_many :course_evaluations
  has_many :attendances
  
  has_one :certificate


  validates_presence_of :course_implementation, 
    :message => ": masukkan kod kursus"

  validates_uniqueness_of :profile_id, 
    :scope => "course_implementation_id",
    :message => "Data peserta sudah ada untuk kursus ini"

  def attendance_percentage
		self.attendances.size * 100/(self.course_implementation.jumlah_hari.to_i*3)
  end

  def all_answered?
    ans = EvaluationAnswer.find_by_sql("SELECT id FROM evaluation_answers WHERE course_application_id=#{self.id} AND course_implementation_id=#{self.course_implementation.id} AND answer ISNULL")
    if ans.size > 0
      return false
    else
      return true
    end
  
  end
  
  def done_evaluation?
    ans = EvaluationAnswer.find_by_sql("SELECT * FROM evaluation_answers where course_application_id=#{self.id} AND course_implementation_id=#{self.course_implementation.id}")
    if ans.size > 0
      return true
    else
      return false
    end
  end
  
  def done_quiz(quiz_id)
    ans = QuizAnswer.find_by_sql("SELECT * FROM quiz_answers where course_application_id=#{self.id} AND course_implementation_id=#{self.course_implementation.id} AND quiz_id =#{quiz_id.to_i}")
    if ans.size > 0
      return true
    else
      return false
    end
  end
  
  def layak?
    if self.layak_sijil == 1
      a = "Layak"
    elsif self.layak_sijil == nil
      a = "n/a"
    else
      a = "Tidak"
    end
  	return a
  end
  
  def fee_paid?
  	if self.payment_date != nil
      return "Y"
    else
      return "T"
    end
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
	
	def get_index
	  orderby = "name"
	  students = CourseApplication.find_by_sql("SELECT ca.id from course_applications ca JOIN profiles p ON ca.profile_id=p.id 
	             WHERE course_implementation_id = #{self.course_implementation.id} 
				 AND student_status_id IN (5,8,9) ORDER BY name")
	  arr = Array.new #[curr student index, next student id, prev student id]

	  i = 0
	  for st in students
	  	if st.id == self.id
        if (i != students.size-1)
          nxt  = students[i+1].id
        else
          nxt  = students[0].id
        end
        prev = students[i-1].id
        arr = [i,st.id,nxt,prev]

        break
      end
      i = i + 1
	  end
	  
	  return arr
		
	end

end
