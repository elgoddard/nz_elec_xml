# require 'net/http'
# require 'open-uri'

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

