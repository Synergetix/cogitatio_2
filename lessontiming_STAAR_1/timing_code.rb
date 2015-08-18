# Code to time scripts (written with Matt)
# It counts the number of [Next] and [Submit, *]
# returns the timing of the individual files
# and calculates the total time


#TO DO: Read in interactively the keywords to search for.
# Enter the keywords in the hash with value 0
# Search and update the value
# Read in interactively the time assigned to each keyword


require 'docx'


#method to loop over files in a folder
#input: path1 is the path of the folder where the scripts are located
# for example: 'C:/Ruby193/code/*.docx'
#calls time_file() to time the files 
#output: Outputs the path of the file followed by the output of time_file().
def time_all (path1, estimate)
	f = File.open('timing_results.txt', 'w')
	total = 0 #total time 
#loop over the files
	Dir.glob(path1).each do |docpath|
#Create a Docx::Document object for our existing docx file
		if(docpath.to_s.scan(/th/).size > 0)
			doc = Docx::Document.open(docpath)
			f.puts(docpath)
			b = time_file(doc, estimate)
			b.each {
				|key, value| 
				if(key=="[Next]")
					f.puts "Total of #{value/6} #{key} taking #{value} seconds"
				else
					f.puts "Total of #{value/estimate} #{key} taking #{value} seconds"
				end
			}
			f.puts "Total Script Time : " + b.values.inject(:+).to_s + " (seconds)"   #sum of times [Next], [Submit], etc. in seconds
			total += b.values.inject(:+)
			f.puts
		end
	end

	f.puts "\nOverall Lesson Time : " + total.to_s + " (seconds)"
	f.close
end



#method to time a single file
#input: the Docx::Document object
#output: the hash with times (in seconds) associated with the total occurrences of keywords
def time_file (doc2, estimate)

#Hash to store the count of [Next], [Submit], etc.
	counthash = Hash.new
	counthash["[Next]"] = 0
	counthash["[Submit]"] = 0

#TO DO: update so that it finds the search criteria from the entered keywords
# Count the number of [Next]s, [Submit, Long]s
# and multiply by the time assigned to each keyword
	doc2.paragraphs.each do |p|
		counthash["[Next]"] += 6*p.to_s.scan(/(\[(n|N)ext)|((n|N)ext\])/).size
		counthash["[Submit]"] += estimate*p.to_s.scan(/\[(S|s)ubmit/).size
	end

#prints times associated with [Next], [Submit, *], etc.
	return counthash

end



#Run the method "time_all"
print "Time estimate for \[Submit\] (in seconds) > "
estimate = gets.chomp.to_i

time_all('./*.docx', estimate)


#time_file doc
#puts Dir["C:/Ruby193/code/*"]
#puts Dir.entries("..")
#puts Dir.entries('C:/Ruby193/code/')
#puts Dir.glob('C:/Ruby193/code/*.docx')
# Dir.glob('C:/Ruby193/code/*.docx').each do |i|
# puts i
# end


# puts "Number of " + counthash.keys[0] + ": " + counthash[counthash.keys[0]].to_s
# puts "Number of " + counthash.keys[1] + ": " + counthash[counthash.keys[1]].to_s
# puts "Number of " + counthash.keys[2] + ": " + counthash[counthash.keys[2]].to_s
# puts "Number of " + counthash.keys[3] + ": " + counthash[counthash.keys[3]].to_s


# puts "Number of [Submit, long]: " + counthash["[Submit, long]"].to_s
# puts "Number of [Submit, medium]: " + counthash["[Submit, medium]"].to_s
# puts "Number of [Submit, short]: " + counthash["[Submit, short]"].to_s
# puts counthash.keys[0]