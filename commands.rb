# require 'net/http'
require 'open-uri'

def sql_upload(sql)
	#If you want to upload data to multiple MySQL servers, replicatate the below line for each server
	#You will also need to add a Class for each server in the database.rb
	SqlDatabase.runQuery($database,sql)
end


def log_report(level,message)
	#Really simple function to enable log reporting
	#Adjust the log level in personal_options.rb and program will print any logs less than your number
	if level.to_i <= $report_level.to_i
		puts message
	end
end


def load_XML(xmlfile)
	@xmlfile = xmlfile
	log_report(5,"Connecting the XML file @ #{@xmlfile}")

	@doc = Nokogiri::XML(open(@xmlfile)) do | config |
		config.noblanks
	end
	@doc.remove_namespaces!

	return @doc
end


def load_HTML(htmlfile)
	@htmlfile = htmlfile
	log_report(5,"Connecting the XML file @ #{@htmlfile}")

	@doc = Nokogiri::HTML(open(@htmlfile)) do | config |
		config.noblanks
	end
	@doc.remove_namespaces!

	return @doc
end


def create_syncs_table
	log_report(9,"Checking if Sync Table Exists")
	tbl_check = "select * from #{$elec}_syncs;"
	begin
		sql_upload(tbl_check).first
	rescue
		log_report(9,"Sync Table doesn't exist. Creating one now")
		sql = "CREATE TABLE #{$elec}_syncs (`sync` int(11) NOT NULL AUTO_INCREMENT, `updated` datetime DEFAULT NULL, `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`sync`)) AUTO_INCREMENT=1;"
		sql_upload(sql)
	end
end

def process_booths(tail)

	puts "Processing the booths."

	load_XML("#{$xml_url}#{tail}")

	##create a booth table
	sql = "drop table if exists #{$elec}_booths; CREATE TABLE #{$elec}_booths ( #{$area}_id int NOT NULL, booth_id int NOT NULL, booth_number int not null, booth_address varchar(200) DEFAULT NULL, orig_name varchar(255) DEFAULT NULL, description varchar(100) DEFAULT NULL, address varchar(100) DEFAULT NULL, suburb varchar(40) DEFAULT NULL, latitude decimal(15,8) DEFAULT NULL, longitude decimal(15,8) DEFAULT NULL, PRIMARY KEY (#{$area}_id,booth_id), KEY idx_booth_id (booth_id) USING BTREE);"
	sql << "truncate #{$elec}_booths; insert into #{$elec}_booths (#{$area}_id,booth_id,booth_number,booth_address) values "

	booths = @doc.xpath("//votingplace")

	booths.each do |bth|
		booth_number = bth['vp_no']
		district_id = bth['e_no']
		booth_id = bth.xpath("./vp_id").text
		booth_address = bth.xpath("./vp_address").text
		sql << "(#{district_id},#{booth_id},#{booth_number},\"#{booth_address}\"),"
	end

	sql  = sql[0..-2]	#chop off the last comma
	sql << ";"
	sql_upload(sql)
	puts "Booths complete."
end

def process_candidates(tail)

	puts "Processing the candidates."

	load_XML("#{$xml_url}#{tail}")

	sql = "drop table if exists #{$elec}_candidates; create table #{$elec}_candidates (#{$area}_id int NOT NULL, candidate_number int, ballot_name varchar(255) DEFAULT NULL, surname varchar(255) DEFAULT NULL, givennames varchar(255) DEFAULT NULL, party int DEFAULT NULL, list_no int default null, PRIMARY KEY (`#{$area}_id`,`candidate_number`));"
	sql << "truncate #{$elec}_candidates; insert into #{$elec}_candidates (#{$area}_id, candidate_number, ballot_name, party, list_no) values "

	candidates = @doc.xpath("//candidate")

	candidates.each do |cand|
		candidate_number = cand['c_no']
		candidate_name = cand.xpath("./candidate_name").text
		electorate = cand.xpath("./electorate").text
		party = cand.xpath("./party").text
		list_no = cand.xpath("./list_no").text
		sql << "(#{electorate},#{candidate_number},\"#{candidate_name}\",#{party},#{list_no}),"
	end

	sql = sql[0..-2]	#chop off the last comma
	sql << ";"
	sql_upload(sql)
	puts "Candidates complete."

end

def process_districts(tail)

	puts "Processing the #{$area}s."

	load_XML("#{$xml_url}#{tail}")

	sql = "drop table if exists #{$elec}_#{$area}s; CREATE TABLE #{$elec}_#{$area}s (  #{$area}_id int(11) NOT NULL,  #{$area} varchar(255) DEFAULT NULL,  enrolment int(5) DEFAULT NULL,  PRIMARY KEY (#{$area}_id),  UNIQUE KEY idx_electorate (#{$area}) USING BTREE);"
	sql << "truncate #{$elec}_#{$area}s; insert into #{$elec}_#{$area}s (#{$area}_id, #{$area}) values "

	electorates = @doc.xpath("//electorate")

	electorates.each do |electorate|
		electorate_number = electorate['e_no']
		electorate_name = electorate.xpath("./electorate_name").text
		sql << "(#{electorate_number},\"#{electorate_name}\"),"
	end

	sql = sql[0..-2]
	sql << ";"
	sql_upload(sql)
	puts "#{$area}s complete."
end

def process_parties(doc)
	@doc = doc

	puts "Processing parties."

	sql = "drop table if exists #{$elec}_parties; CREATE TABLE #{$elec}_parties ( code varchar(5) NOT NULL, name varchar(50) DEFAULT NULL, PRIMARY KEY (`code`));"
	sql << "truncate #{$elec}_parties; insert into #{$elec}_parties (code, name) values "

	party = @doc.xpath("//parties/party")
	party.each do |part|
		sql << "(\"#{part['code']}\", \"#{part['name']}\"),"
	end
	sql = sql[0..-2]
	sql << ";"
	sql_upload(sql)
	puts "Parties complete."
end