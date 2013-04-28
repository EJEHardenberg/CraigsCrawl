#!/usr/bin/env ruby

		class Parser
	def stripHead(document)
=begin
Strips the Head of an html document out and returns the stripped document
:document The document to be stripped
=end
document.sub!(/<head(.*)head>/im,'')
document
	end

end

	if __FILE__==$0
p = Parser.new
puts p.stripHead("<html><head>This will be stripped</heAd>Not so much")
	end