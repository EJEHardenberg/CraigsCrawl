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
	@validationData
	@classes

	def initialize(fileName='dump.data')
		#Crawl the web
		@cls = StuffClassifier::Bayes.new("Craigs", :stemming=>true)
		#The  lines below can be commented out once the pages have been crawled
		spider = Crawler.new(20,'burlington.craigslist.org','/roo/index','/roo/index.html',fileName)
		begin
			spider.deepCrawl()	
		rescue Exception => e
			#whatever
			puts "Interupted during crawl"
			Utility.writeDataSet(spider.gatheredData,spider.fileToWrite)
		end
		#go to sleep little program
		puts "sleeping"
		sleep(2)
		puts "waking up and spamming craigslist"
		spider = Crawler.new(20,'burlington.craigslist.org','/apa/index','/apa/index.html',fileName)
		begin
			spider.deepCrawl()	
		rescue Exception => e
			puts "Interupted during crawl"
			Utility.writeDataSet(spider.gatheredData,spider.fileToWrite)
		end
		
		@rawData = Utility.readDataSet(fileName)
		puts @rawData.length
		#Break it into price brackets
		@rawData = Utility.priceBracket(@rawData)

		#Train the classifier
		generateTrainingData()
		train()
		validate()
	end

	def generateTrainingData()
		@trainingData = Array.new
		@validationData = Array.new
		included = 0
		@rawData.each do |data|
			#include every 3rd data piece in
			if included % 5 == 1
				@trainingData << data
			else
				@validationData << data
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
		@validationData.each do |data| 
			targetClass = data['location']
			guess = @cls.classify(data['title'])
			if guess != nil
				guess =guess.to_s.upcase
			end
			if guess == targetClass.to_s.upcase
				puts "Target: " + targetClass.to_s.upcase + " Guess: " + guess.to_s.upcase
				correct += 1
			else
				puts "Target: " + targetClass.to_s.upcase  + " Guess: " + (guess==nil ? 'no' : guess.to_s)
				wrong +=1
			end
		end
		puts "Correct: " + correct.to_s + " Wrong: " + wrong.to_s
	end

end

if __FILE__ == $0
	Miner.new
end