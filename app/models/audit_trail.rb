# -*- encoding : utf-8 -*-
class AuditTrail < ActiveRecord::Base
	belongs_to :user
end
