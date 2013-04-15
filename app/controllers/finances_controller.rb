class FinancesController < ApplicationController
  layout "standard-layout"
  
  def claim_payment_list
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from timetable_date)as year from claim_payments ORDER BY year DESC").collect(&:year)
    condition = ""
    condition += "status = '#{params[:filter_status]}'" if  (params[:filter_status].present? && params[:filter_status] != "all")
    if params[:tarikh_month].present? && params[:tarikh_year].present?
      if condition.present?
        condition += " AND "
      end
      condition += "EXTRACT(month FROM timetable_date) = #{params[:tarikh_month]} AND EXTRACT(year FROM timetable_date) = #{params[:tarikh_year]}"
    end
    @claim_payments = ClaimPayment.where(condition).order("timetable_date DESC").paginate(:per_page => 20, :page => params[:page])
  end

  def search_claim_payment
    @planning_months = [["Januari","01"],["Februari","02"],["Mac","03"],["April","04"],["Mei","05"],["Jun","06"],["Julai","07"],["Ogos","08"],["September","09"],["Oktober","10"],["November","11"],["Disember","12"]]
    @planning_years = ClaimPayment.find_by_sql("SELECT distinct extract(year from timetable_date)as year from claim_payments ORDER BY year DESC").collect(&:year)
    if params[:ic_number].present?
      profile = Profile.find_by_ic_number(params[:ic_number])
      if profile.present?
        if profile.trainer.present?
          condition = "trainer_id = '#{profile.trainer.id}'"
          condition += " AND status = '#{params[:filter_status]}'" if  (params[:filter_status].present? && params[:filter_status] != "all")
          if params[:tarikh_month].present? && params[:tarikh_year].present?
            condition += " AND EXTRACT(month FROM timetable_date) = #{params[:tarikh_month]} AND EXTRACT(year FROM timetable_date) = #{params[:tarikh_year]}"
          end
          @claim_payments = ClaimPayment.where(condition).order("timetable_date DESC")
        else
          flash.now[:notice] = "tenaga pengajar dengan ic number #{params[:ic_number]} tidak ditemukan"
          @claim_payments =[]
        end
      else
        flash.now[:notice] = "tenaga pengajar dengan ic number #{params[:ic_number]} tidak ditemukan"
        @claim_payments =[]
      end
    else
      @claim_payments =[]
    end
  end

  def claim_payment_approve
    
    totals_approved = params[:total_approved]
    claim_ids_approved = params[:dilulus]
    #raise claim_ids_approved.inspect
    claim_ids_approved.each do |index, id|
      #raise id.inspect
      claim_row= ClaimPayment.find(id) rescue nil
      if claim_row.present?
        claim_row.update_attributes(:total_approved	=> totals_approved[index], :status => "dilulus")
      end
    end
    flash[:notice] = "Tuntutan bayaran yang dipilih telah dikemaskinikan"
    redirect_to request.referer
  end
end