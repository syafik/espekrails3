# -*- encoding : utf-8 -*-
module PlacesHelper
  def places
    @places = Place.find(:all, :conditions => "place_type_id = '1'")
  end
end
