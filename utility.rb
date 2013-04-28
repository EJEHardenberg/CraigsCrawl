#!/usr/bin/env ruby

=begin 
utility.rb
:file
The Utility class contains miscellaneous functions such as writing and reading the dataset, as well as generating documentation
=end

class Utility
	def self.writeDataSet(dataset=nil,fileName='dump.txt')
=begin 
writeDataSet
Writes data collected from crawls to the fileToWrite
:dataset The dataset to be written out
:fileName The name of the file to create/append to
=end
		if(dataset != nil)
			fd = File.new(fileName,'a')
			dataset.each do |post|
				puts post.inspect
				fd.puts( post['title']+ ', ' + post['location'] )
			end
			fd.close()
		end
	end

	def self.readDataSet(fileName='dump.txt')
=begin 
readDataSet
Reads data from the specified fileName and returns an array of Hashmap
:fileName The name of the file to open and read the dataSet out from
=end
		fd = File.new(fileName)
		data = Array.new
		while line = fd.gets
			h = Hash.new("Post")
			info = line.split(',')
			h['title'] = info[0]
			h['location'] = info[1]
			data << h
		end
		fd.close()
		data
	end
end

if __FILE__==$0
	puts (Utility.readDataSet()).inspect
end