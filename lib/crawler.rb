#!/usr/bin/env ruby

require 'net/http'
require 'parser'
require 'utility'

=begin
crawler.rb
:file
This class crawls the web and loads up the website then attempts to grab a bunch of data for the parser to take care of
We can specify how many pages we want simply by manipulating the url /apa/index/#00.html to get 1000 results really fast. 
http://burlington.craigslist.org/apa/index200.html
=end

class Crawler
	attr_accessor :pagesToCrawl
	attr_accessor :host
	attr_accessor :basePage
	attr_accessor :startPage
	attr_accessor :currentResult
	attr_accessor :fileToWrite
	attr_accessor :gatheredData

	def initialize(pages=9,host='burlington.craigslist.org',base='/apa/index',start='/apa/index.html',fileName="dump.data")
=begin
initialize
Creates a crawler object with the specified parameters.
:pages The number of pages to attempt to crawl using the base
:host The base url which the base and start pages will use
:base The base of pages we are crawling
:start The starting page to crawl
:fileName The name of the file to save the results of the crawl to
=end
		@pagesToCrawl = pages
		@host = host
		@basePage =  base
		@startPage = start
		@currentResult = nil
		@fileToWrite = fileName
		@gatheredData = Array.new 
	end

	def crawl(page)
=begin
crawl
Crawls a single page.
:page The page to crawl 
=end
		begin
			@currentResult = Net::HTTP.get(@host, page)	
		rescue Exception => e
			puts "Failed crawling " + page.to_s
		end
		
	end

	def craigsCrawl()
=begin
craigsCrawl
This function crawls the base page first, then iterates through however many pages we've requested from craigslist.
:none No Parameters
=end

		#generate list of pages to be crawled
		pages = [@startPage,genPages()].flatten

		#Crawl each page and pass it to the parser
		allPostings = Array.new
		parser = Parser.new
		pages.each do |page|
			puts "Crawling " + page
			crawl(page)
			posts = parser.findPostings(@currentResult)
			posts.each{|post| allPostings << post}
		end

		Utility.writeDataSet(allPostings.flatten,@fileToWrite)
	end

	def deepCrawl()
=begin
deepCrawl
This function crawls a basic page, retrieves the links from it, and then follows each link to retrieve more descriptive data
:none No Parameters
=end
		#generate list of pages to be crawled
		pages = [@startPage,genPages()].flatten

		#Crawl each page and pass it to the parser
		allPostings = Array.new
		parser = Parser.new
		
		pages.each do |page|
			crawl(page)
			#Get the price,title, and link
			posts = parser.findPostings(@currentResult)
			#Crawl the link and retrieve it's info, appending to the title to make it easier
			posts.each do |post|
				crawl(post['link'])
				body = parser.getPostBody(@currentResult)
				if body != nil
					#only include it if we can get the body
					post['title'] = post['title'].gsub(',','') + ' ' +  body.gsub(',','')
					allPostings << post
					@gatheredData << post
				end
			end
		end

		#Write out that data!
		Utility.writeDataSet(allPostings.flatten,@fileToWrite)
		
	end

	def genPages()
=begin
genPages
Generates an array of page names created from the basePage. The pages will be in the form of basePage100.html ... up to basePage(pagesToCrawl)00.html
:none No Parameters
=end
		pages = Array.new
		(1..(pagesToCrawl-1)).each{|i| pages << @basePage + i.to_s() + '00' + '.html'  }
		#Ruby probably wants me to just say pages and let it's magic handle it but I really do prefer an explicit return
		return pages
	end
	 
end


if __FILE__ == $0
	c = Crawler.new(pages=1)
	puts c.genPages()
	c.deepCrawl()
end