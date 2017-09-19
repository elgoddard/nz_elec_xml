#!/usr/bin/ruby

require 'nokogiri'

require_relative 'options'
require_relative 'database'
require_relative 'commands'

puts "Auto Election Upload for #{$elec}"
#puts "Checking for RUN in download table"

## TODO insert a check if we should do the process

if $run_method == 'setup'
	process_booths("votingplaces.xml")
	process_candidates("candidates.xml")
	process_districts("electorates.xml")
	process_parties("parties.xml")
	create_results_table	#only creates if doesn't exist
	create_votetypes_table	#only creates if doesn't exist
	# create_views			#drops view and recreates
elsif $run_method == 'results'
	process_results
end