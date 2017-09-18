# nz_elec_xml
Code to parse NZ Election XML feed


Run each of the main files to generate a text file of the data.

Eg. `ruby booths.rb` will generate a pipe delineated file of the booths.
Same for parties, candidates, and electorates

Results are stored in separate folders for each electorate, and each booth as its own XML doc.
results.rb will iterate through each electorate and through each XML booth. It will save the results in a pipe delineated file results.txt

# ToDo
* Upload direct to MySQL