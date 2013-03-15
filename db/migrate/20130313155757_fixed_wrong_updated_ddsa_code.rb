class FixedWrongUpdatedDdsaCode < ActiveRecord::Migration
  def up
    YAML::load(File.open "#{Rails.root}/config/contact.yml").each do |contact|
      unless contact["kod_baru"].blank?
        wrong_kod = contact["kod_baru"].to_s.split("/").first

        place = Place.where(["code = ?", "#{wrong_kod}"]).first
        if place
          place.code = contact["kod_baru"].to_s
          place.name = contact["jabatan"]
          place.save validate: false
        end
      end
    end
  end

  def down
  end
end
