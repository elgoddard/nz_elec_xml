#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require_relative 'commands.rb'

puts "This will parse the booths for upcoming NZ election and save to CSV"

load_XML('http://media.election.net.nz/xml/votingplaces.xml')

booths = @doc.xpath("//votingplace")
bths = "booth_number|district_id|booth_id|booth_address"

booths.each do |bth|
	booth_number = bth['vp_no']
	district_id = bth['e_no']
	booth_id = bth.xpath("./vp_id").text
	booth_address = bth.xpath("./vp_address").text
	bths << "#{booth_number}|#{district_id}|#{booth_id}|#{booth_address}\n"
end

File.open("booths.txt", 'w') { |file| file.write(bths) }

puts "Download complete. The file has been saved in the directory as booths.txt"
