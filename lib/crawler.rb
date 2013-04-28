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
	end

	def crawl(page)
=begin
crawl
Crawls a single page.
:page The page to crawl 
=end
		@currentResult = Net::HTTP.get(@host, page)
	end

	def craigsCrawl()
=begin
craigsCrawl
This function crawls the base page first, then iterates through however many pages we've requested from craigslist.
:none No Parameters
=end

		#generate list of pages to be crawled
		pages = [@startPage,genPages()].flatten

		#Crawl each page and pass it to the parser (parser on todo list)
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
	c = Crawler.new(pages=10)
	puts c.genPages()
	c.craigsCrawl()
end