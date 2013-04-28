#!/usr/bin/env ruby

require 'rubygems'
require 'stuff-classifier'
require 'crawler'
require 'utility'

=begin
miner.rb
:file
The miner class reads the data found by the crawler and attempts to construct a classifier which is able to accurately classify the data
=end

class Miner
	@cls
	@rawData
	@trainingData
	@classes

	def initialize(fileName='dump.data')
		#Crawl the web
		#@cls = StuffClassifier::TfId.new("Craigs")
		@cls = StuffClassifier::Bayes.new("Craigs")
		#The two lines below can be commented out once the pages have been crawled
		#spider = Crawler.new(15,'burlington.craigslist.org','/apa/index','/apa/index.html',fileName)
		#spider.craigsCrawl()
		@rawData = Utility.readDataSet(fileName)
		@classes = Utility.getDistinctClasses(@rawData)
		puts  @classes.length
		#@classes.each{|c,n| puts c.to_s + 'examples: ' + n.to_s}
		@trainingData = Array.new
		generateTrainingData()
		train()
		validate()
	end

	def generateTrainingData()
		included = 0
		@rawData.each do |data|
			#include every 3rd data piece in
			if included % 3 == 0
				@trainingData << data
			end
			included += 1
		end
	end

	def train()
		@trainingData.each do |d|
			@cls.train(d['location'], d['title'])
		end
	end

	def validate()
		correct=0
		wrong = 0
		@rawData.each do |data| 
			targetClass = data['location']
			guess = @cls.classify(data['title'])
			if guess == targetClass
				correct += 1
			else
				wrong +=1
			end
		end
		puts "Correct: " + correct.to_s + " Wrong: " + wrong.to_s
	end

end

if __FILE__ == $0
	Miner.new
end