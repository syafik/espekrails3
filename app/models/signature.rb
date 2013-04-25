# -*- encoding : utf-8 -*-
class Signature < ActiveRecord::Base
  set_primary_key :id
  attr_accessible :filename, :person_name, :person_position, :description
  #def self.save(signature)
  	# `cp #{person.picture.path} pictures/#{person.name}/picture.jpg`
  	#File.open("public/signatures/#{signature['filename']}", "w") { |f| f.write(signature['filename'].read) }
  #end

	#if RUBY_PLATFORM == "i386-mswin32"
	#	pdf.save_as("public/maklumat_pemohon/" + file) #kat windows
	#else
	#	pdf.save_as("/aplikasi/www/instun/public/maklumat_pemohon/" + file) #kalu kat bsd
	#end
	validates_presence_of :person_name
	validates_presence_of :person_position
	#validates_presence_of :filename
end
