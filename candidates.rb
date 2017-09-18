#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require_relative 'commands.rb'

puts "This will parse the candidates for upcoming NZ election and save to CSV"

load_XML('http://media.election.net.nz/xml/candidates.xml')

candidates = @doc.xpath("//candidate")
cands = "candidate_number|candidate_name|electorate|party|list_no"

candidates.each do |cand|
	candidate_number = cand['c_no']
	candidate_name = cand.xpath("./candidate_name").text
	electorate = cand.xpath("./electorate").text
	party = cand.xpath("./party").text
	list_no = cand.xpath("./list_no").text
	cands << "#{candidate_number}|#{candidate_name}|#{electorate}|#{party}|#{list_no}\n"
end

File.open("candidates.txt", 'w') { |file| file.write(cands) }

puts "Download complete. The file has been saved in the directory as candidates.txt"
