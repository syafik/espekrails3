# -*- encoding : utf-8 -*-
class CoursesTrainer < ActiveRecord::Base
	belongs_to :course
	belongs_to :trainer
end
