class UpdateDssCode < ActiveRecord::Migration
  def up
    YAML::load(File.open "#{Rails.root}/config/contact.yml").each do |contact|
      place = Place.where(["code = ?", "#{contact["kod_lama"]}"]).first
      if place
        unless contact["kod_baru"].blank?
          kod_baru = contact["kod_baru"].to_s.split("/").first
          place.code = kod_baru
        end
        place.name = contact["jabatan"]
      else
        place = unless contact["kod_baru"].blank?
          kod_baru = contact["kod_baru"].to_s.split("/").first
          Place.new code: kod_baru, name: contact["jabatan"]
        else
          Place.new code: contact["kod_lama"], name: contact["jabatan"]
        end
      end
      place.save validate: false
    end
  end

  def down
  end
end
