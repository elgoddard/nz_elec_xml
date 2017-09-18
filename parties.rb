#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require_relative 'commands.rb'

puts "This will parse the parties for upcoming NZ election and save to CSV"

load_XML('http://media.election.net.nz/xml/parties.xml')

parties = @doc.xpath("//party")
parts = "party_number|abbreviation|short_name|long_name|registered"

parties.each do |party|
	party_number = party['p_no']
	abbreviation = party.xpath("./abbrev").text
	short_name = party.xpath("./short_name").text
	long_name = party.xpath("./party_name").text
	registered = party.xpath("./registered").text
	parts << "#{party_number}|#{abbreviation}|#{short_name}|#{long_name}|#{registered}\n"
end

File.open("parties.txt", 'w') { |file| file.write(parts) }

puts "Download complete. The file has been saved in the directory as parties.txt"
