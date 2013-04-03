# -*- encoding : utf-8 -*-
module TrainerHelper

  def check_claim_status(timtable_id, trainer_id)
    exist = ClaimPayment.where(:trainer_id =>trainer_id, :timetable_id => timtable_id)
    if exist.present?
      return true
    else
      return false
    end
  end

  def get_claim_status(timtable_id, trainer_id)
    exist = ClaimPayment.where(:trainer_id =>trainer_id, :timetable_id => timtable_id)
    if exist.present?
      return exist[0].status
    else
      return ""
    end
  end

  def get_total_approved(timtable_id, trainer_id)
    exist = ClaimPayment.where(:trainer_id =>trainer_id, :timetable_id => timtable_id)
    if exist.present? && exist[0].status == "dilulus"
      return exist[0].total_approved
    else
      return "-"
    end
  end

end
