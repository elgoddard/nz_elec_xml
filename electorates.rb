#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require_relative 'commands.rb'

puts "This will parse the electorates for upcoming NZ election and save to CSV"

load_XML('http://media.election.net.nz/xml/electorates.xml')

electorates = @doc.xpath("//electorate")
elecs = "electorate_number|electorate_name"

electorates.each do |electorate|
	electorate_number = electorate['e_no']
	electorate_name = electorate.xpath("./electorate_name").text
	elecs << "#{electorate_number}|#{electorate_name}\n"
end

File.open("electorates.txt", 'w') { |file| file.write(elecs) }

puts "Download complete. The file has been saved in the directory as electorates.txt"
