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
		@cls = StuffClassifier::Bayes.new("Craigs", :stemming=>false)
		#The two lines below can be commented out once the pages have been crawled
		spider = Crawler.new(50,'burlington.craigslist.org','/roo/index','/roo/index.html',fileName)
		spider.craigsCrawl()
		spider = Crawler.new(50,'burlington.craigslist.org','/apa/index','/apa/index.html',fileName)
		spider.craigsCrawl()
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
		included = 0
		@rawData.each do |data|
			#include every 3rd data piece in
			if included % 3 == 1
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