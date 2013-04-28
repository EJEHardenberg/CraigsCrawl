#!/usr/bin/env ruby

require 'rubygems'
require 'stuff-classifier'
require 'crawler'
require 'utility'

cls = StuffClassifier::Bayes.new("Cats or Dogs", :stemming=>false)
cls.train(:dog, "Dogs are awesome, cats too. I love my dog")
cls.train(:cat, "Cats are more preferred by software developers. I never could stand cats. I have a dog")    
cls.train(:dog, "My dog's name is Willy. He likes to play with my wife's cat all day long. I love dogs")
cls.train(:cat, "Cats are difficult animals, unlike dogs, really annoying, I hate them all")
cls.train(:dog, "So which one should you choose? A dog, definitely.")

puts cls.classify("The most annoying animal on earth.")

=begin
miner.rb
:file
The miner class reads the data found by the crawler and attempts to construct a classifier which is able to accurately classify the data
=end

class Miner
	@cls = StuffClassifier::Bayes.new("Craigs")
	@rawData 
	@trainingData
	@classes

	def initialize(fileName='dump.data')
		#Crawl the web
		spider = Crawler.new(1,'burlington.craigslist.org','/apa/index','/apa/index.html',fileName)
		spider.craigsCrawl()
		@rawData = Utility.readDataSet(fileName)
		@classes = Utility.getDistinctClasses(@rawData)
		generateTrainingData()
		train()
	end

	def generateTrainingData()
		include = 0
		@rawData.each do |data|
			#include every 3rd data piece in
			if include % 3 == 0
				@trainingData << data
			end
		end
	end

	def train()
		@trainingData.each do |d|
			cls.train(d['location'], d['title'])
		end
	end

	def validate()
		correct=0
		wrong = 0
		@rawData.each do |data| 
			
		end
	end

end

if __FILE__ == $0
	Miner.new
end