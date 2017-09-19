# nz_elec_xml #

### What is this repository for? ###

* Prase the NZ Election Night XML feed
* There are code files which will prase to TXT file, or a RUN file to upload direct to MySQL
* Version 1

### Set up ###

* duplicate example_options and rename options
* Update options with your settings and set run_method to setup

### Run ###

* Type `ruby run.rb` within console
* This will create the base tables and import main data
* Change the run_method to results so it will then upload results


### Alternative Run ###

* Run each of the main files to generate a text file of the data.

* Eg. `ruby booths.rb` will generate a pipe delineated file of the booths.
* Same for parties, candidates, and electorates

* Results are stored in separate folders for each electorate, and each booth as its own XML doc.
* results.rb will iterate through each electorate and through each XML booth. It will save the results in a pipe delineated file results.txt

### ToDo

* Create a couple views to see all the data

### Who do I talk to? ###

* jwood74 - Jaxen Wood - jw@jaxenwood.com







