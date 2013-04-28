#!/usr/bin/env ruby

=begin
utility.rb
:file
The Utility class contains miscellaneous functions such as writing and reading the dataset, as well as generating documentation
=end

class Utility
	@@template = '../doc/main_template.html'
	@@docPath = '../doc/'
	def self.writeDataSet(dataset=nil,fileName='dump.data')
=begin
writeDataSet
Writes data collected from crawls to the fileToWrite
:dataset The dataset to be written out
:fileName The name of the file to create/append to
=end
		if(dataset != nil)
			fd = File.new(fileName,'a')
			dataset.each do |post|
				fd.puts( post['title']+ ', ' + post['location'].strip.upcase )
			end
			fd.close()
		end
	end

	def self.readDataSet(fileName='dump.data')
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
			h['location'] = info[1].strip.upcase.to_sym
			data << h
		end
		fd.close()
		data
	end

	def self.findBlocks(file_contents)
=begin
findBlocks
Takes a string and returns hashmaps of each block comment information 
:file_contents The string to be read and parsed for block comments
=end
		blocks = file_contents.scan(/^=begin(.*?)=end/im).flatten
		blockMap = Array.new
		blocks.each do | block | 
			block = block
			#Grab the lines our of the block and remove any lines of emptiness
			lines = block.scan(/^(.*?)$/).flatten - [""]
			#Check for file doc
			if lines[1].match(/:file\s*(.*)/)
				h = Hash.new("file")
				h['file'] = true
				h['desc'] = block.scan(/:file(.*)/im).flatten[0].strip
			else
				h = Hash.new
				h['file'] = false
				h['desc'] = lines[1] #Info string
				#Get the parameters
				paramNames = lines[2].scan(/:(.*?)\s/).flatten
				paramStrings = lines[2].scan(/:[A-za-z]*\s(.*)/i).flatten
				paramsList = Array.new
				i=0
				paramNames.each do |name|
					p = Hash.new
					p['name'] = name
					p['desc'] = paramStrings[i]
					paramsList << p
					i=i+1
				end
				h['params'] = paramsList
			end
			h['name'] = lines[0] #First line is name of function or file
			
			blockMap << h
		end
		blockMap
	end

	def self.documentFile(fileName)
=begin
documentFile
Reads a files contents and generates documentation for that file
:fileName The name of the file to generate the documentation for
=end
		fd = File.new(fileName)
		#DO WORK
		puts "Documenting " + fileName
		docString = ""
		blocks = findBlocks(fd.read)
		fd.close()
		#Open up the template
		tmp = File.new(@@template)
		docString = tmp.read
		tmp.close()
		#Grab the file block
		fBlock = getFileBlock(blocks)
		#Write out the basic information into the template if they've included it
		if fBlock
			docString.sub!(/TITLE_DOCUMENTATION/,fBlock['name'])
			docString.sub!(/FILENAME/,fBlock['name'])
			docString.sub!(/FILEDESC/,fBlock['desc'])
		end
		docString.sub!(/FILELIST/,createFileList())
		#format each block then write it to the file
		blockString = ''
		blocks.each{ |block| blockString << formatBlock(block)}
		docString.sub!(/BLOCKS/,blockString)

		#write out the function names
		funcNames = getFunctionNames(blocks)
		funcList = "<ul>"
		funcNames.each{|funcName| funcList << "<li><a href='#" + funcName['name'] + "' >" + funcName['name'] + "</a></li>"}
		funcList << "</ul>"
		docString.sub!(/FUNCTIONLIST/,funcList)


		#Write our the document
		docFile = File.new(@@docPath + fileName + '.doc.html','w')
		docFile.puts docString
		docFile.close()


	end

	def self.getFunctionNames(blocks)
		names = Array.new
		blocks.each do |block| 
			if(!block['file'])
				names << block['name']
			end
		end	
	end

	def self.getFileBlock(blocks)
=begin
getFileBlock
Retrieves the file block from an array of blocks. Returns nil if no file block found
:blocks An array of block hashes
=end
		blocks.each do |block| 
			if(block['file'])
				return block
			end
		end
		nil
	end

	def self.formatBlock(block)
=begin 
formatBlock
Creates a div for the block and adds the information into it
:blocks An array of block hashes
=end
		docBlock = ''
		if(!block['file'])
			docBlock << "<div id='"+block['name']+"' class='block'><h3>" + block['name'] + "</h3><p>" + block['desc'] + '</p>'
			if block['params'].any?
				docBlock << "<h4>Parameters</h4><dl>"
				block['params'].each do |param|
					docBlock << "<dt>" + param['name'] + "</dt><dd>" + param['desc'] + "</dd>"
				end
				docBlock << "</dl></div>"
			end
		end
		docBlock
	end


	def self.createFileList()
		ls = Dir.entries(Dir.pwd)
		#IF they're a ruby file, lets doc em
		docString = "<ul>"
		ls.each do |file| 
			if file.match(/\.rb$/im)
				docString << "<li><a href='"+file+".doc.html' >" + file.sub(/\.rb$/,'') + "</a></li>"
			end
		end
		docString << "</ul>"
		docString
	end

	def self.documentFiles()
		ls = Dir.entries(Dir.pwd)
		#IF they're a ruby file, lets doc em
		ls.each do |file| 
			if file.match(/\.rb$/im)
				documentFile(file)
			end
		end
	end

	def self.getDistinctClasses(dataList)
=begin
getDistinctClasses
Parses the data for distinct locations and returns a list of these
:dataList The data to be parsed, hash objects of {title=>'',location=>''} expected
=end
		dist = Hash.new
		dataList.each do |data|
			dist[data['location']] = dist.has_key?(data['location']) ? dist[data['location']] + 1 : 1
		end
		dist
	end
end

if __FILE__==$0
	#puts (Utility.readDataSet()).inspect
	Utility.documentFiles()
	puts "Done documenting"
end