#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require_relative 'commands.rb'

puts "This will parse the results for upcoming NZ election and save to CSV"

results = "electorate_number|booth_number|ttype|number|votes\n"

(01..71).each do |num|
	num = num.to_s.rjust(2,'0')
	link = "http://media.election.net.nz/xml/e#{num}/votingplaces/"
	puts link
	page = load_HTML(link)
	as = page.xpath(".//a")
	as.each do |a|
		if a.text.include? "xml"
			link2 = "http://media.election.net.nz/xml/e#{num}/votingplaces/#{a.text}"
			puts link2
			bth = load_XML(link2)

			vp = bth.at_xpath("./votingplace")

			parties = bth.xpath("//party")
			parties.each do |party|
				party_number = party['p_no']
				p_votes = party.xpath("./votes").text
				results << "#{vp['e_no']}|#{vp['vp_no']}|'p'|#{party_number}|#{p_votes}\n"
			end

			candidates = bth.xpath("//candidate")
			candidates.each do |candidate|
				candidate_number = candidate["c_no"]
				c_votes = candidate.xpath("./votes").text
				results << "#{vp['e_no']}|#{vp['vp_no']}|'c'|#{candidate_number}|#{c_votes}\n"
			end
		end
	end
end

File.open("results.txt", 'w') { |file| file.write(results) }

puts "Download complete. The file has been saved in the directory as results.txt"
