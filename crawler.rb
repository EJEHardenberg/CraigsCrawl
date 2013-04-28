#!/usr/bin/env ruby

require 'net/http'
=begin
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

	def initialize(pages=9,host='burlington.craigslist.org',base='/apa/index',start='/apa/index.html')
		@pagesToCrawl = pages
		@host = host
		@basePage =  base
		@startPage = start
		@currentResult = nil
	end

	def crawl(page)
		currentResult = Net::HTTP.get(@host, page)
	end

	
	 
end