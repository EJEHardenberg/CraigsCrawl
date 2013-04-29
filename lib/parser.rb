#!/usr/bin/env ruby

=begin
parser.rb
:file
The Parser class provides a simple interface to grab the relevant data from a craigs list posting. 
It uses some simple reg ex to parse the structure html of the page. Luckily this isn't the case of 
html being impossible to parse with regular expressions.
=end

class Parser

	def stripHead(document)
=begin
stripHead
Strips the Head of an html document out and returns the stripped document
:document The document to be stripped
=end
	document.sub(/<head(.*)head>/im,'')
	end
	def stripHead!(document)
=begin
stripHead!
Strips the Head of an html document out and returns the stripped document, modifies original document
:document The document to be stripped
=end
	document.sub!(/<head(.*)head>/im,'')
	document
	end

	def stripJavascript(document)
=begin
stripJavascript
Strips any thing between script tags out of the document
:document The document to be stripped
=end
	document.sub(/<script[^>]*>(.*?)script>/im,'')
	end
	def stripJavascript!(document)
=begin
stripJavascript! 
Strips any thing between script tags out of the document, modifys document
:document The document to be stripped
=end
	document.sub!(/<script[^>]*>(.*?)script>/im,'')
	document
	end

	def stripHeaders(document)
=begin
stripHeaders
Strips H1,H2,H3s... out of the document
:document The document to be stripped
=end
	document.sub(/<h[0-9]*[^>]*>(.*?)<\/h[0-9]*>/im,'')
	end
	def stripHeaders!(document)
=begin
stripHeaders!
Strips H1,H2,H3s... out of the document, modifies parameter
:document The document to be stripped
=end
	document.sub!(/<h[0-9]*[^>]*>(.*?)<\/h[0-9]*>/im,'')
	document
	end

	def findPostings(document)
=begin
findPostings
Find the list of p tags that represent postings in craigslist
:document The document to be stripped
=end
#Whittle the string size down so our regex doesn't take too long
	stripHead!(document)
	stripJavascript!(document)
	stripHeaders!(document)

	#Use the nicely structure format of craigslist to grab the postings
	postings = Array.new
	res = document.scan(/<p class="row" [^>]*>(.*?)<\/p>/im)
	res.each{|i| postings << i}
	postings.flatten!

	#Grab the title text (this will be the training data)
	posts = Array.new
	postings.each do |post|
		#The second match is always the title
		h = Hash.new("Posting")
		h["title"] = post.scan(/<a href[^>]*>(.*?)<\/a>/im).flatten[1].gsub(',','').strip
		h['location'] = post.scan(/<span class="itemprice">\$(.*?)<\/span>/im).flatten[0]
		if h['location'] != nil 
			h['location'].gsub!(',','')
			posts <<  h
		end
	end

	posts
	end

end

	if __FILE__==$0
document='
<!DOCTYPE html>
<html><head>
	<title>vermont apts/housing for rent classifieds  - craigslist</title>

	<meta name="description" content="vermont apts/housing for rent classifieds  - craigslist">
	<link rel="alternate" type="application/rss+xml" href="/apa/index.rss" title="RSS feed for craigslist | apts/housing for rent  in vermont ">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=1">
	<link type="text/css" rel="stylesheet" media="all" href="http://www.craigslist.org/styles/clnew.css?v=8fb841c00e059cf0dc8b5f466f287617">
	
    
	
		<script type="text/javascript"><!--
			var currencySymbol = null;
var unmappableNotShownText = "unmappable items not shown";
var clearShortlistText = "clear shortlist";
var viewPostingText = "view posting";
var zoomToPosting = null;
var showInfoText = "show info";
var moreInfoText = "more info";
var showImageText = "show images";
var imageHost = "http://images.craigslist.org";
var showMapTabs = 1;
var lessInfoText = "less info";
var removeFromShortlistText = "remove from shortlist";
var shortlistViewText = "shortlist view";
var pID = null;
var shortlistNoteText = "SHORTLISTED";
var addToShortlistText = "add to shortlist";

		--></script>
	
	<!--[if lt IE 9]>
<script type="text/javascript" src="http://www.craigslist.org/js/html5shiv.js?v=ed7af45dcbda983c8455631037ebcdda"></script>
<![endif]-->
</head>

<body class="toc">
<script type="text/javascript"><!--
	var pagetype;
	function C(k){return(document.cookie.match(\'(^|; )\'+k+\'=([^;]*)\')||0)[2]}
	var fmt = C(\'cl_fmt\');
	var b = document.body;
	pagetype = b.className;
	if (fmt !== '') { b.className += " " + fmt; }
	var width = window.innerWidth || document.documentElement.clientWidth;
	if (width > 1000) { b.className += \' w1024\'; }
	var mode = C(\'cl_img\');
	if (mode !== '') { b.className += " " + mode; }
--></script>


	<article id="pagecontainer">

		<header class="bchead">
	<div class="contents">
		<div class="topright_box">
			<div id="ef">
	[ <a href="http://www.craigslist.org/about/help/">help</a> ] 
	[ <a href="https://post.craigslist.org/c/brl/H?lang=en">post</a> ]
</div>

			<div id="favorites" class="highlight">
    <a href="#"><span class="n">0</span> favorites</a>
</div>

		</div>
		<div class="dropdown down">&or;</div>
		<div class="dropdown up">&and;</div>
		<div class="leftside">
            <button class="back">&lt;</button>
            <div class="breadbox">
                <div class="breadcrumbs">
                    <span class="crumb"><a href="//www.craigslist.org/about/sites">CL</a></span>
                    <span class="crumb"><a href="/">vermont</a></span>    <span class="crumb"><a href="/hhh/">housing</a></span> <span class="crumb"><a href="/apa/">apts/housing for rent</a></span>
                </div>
            </div>
		</div>
        
	</div>
</header>


		<blockquote>

		<script type="text/javascript"><!--
			var catAbb = "apa";

		--></script>
	
<form action="/search/apa" id="searchform" method="get">

    <fieldset id="searchfieldset">
    <legend id="searchlegend">apts/housing for rent</legend>
	<table id="searchtable" width="100%" cellpadding="2" summary="">
		<tr>
			<td align="right">search for:</td>

			<td>
				<div id="searchchecks">
                    <label id="usemapcheck" style="display:none;">
						<input type="checkbox" name="useMap" value="1">show map
					</label>
                    <label id="shortlistcheck" style="display:none;">
						<input type="checkbox" name="shortlistOnly" value="1">show shortlisted items only
					</label>
					<input id="zoomtoposting" type="hidden" name="zoomToPosting" value="">
				</div>
				<input id="query" name="query" size="24" value=""> in:
				<select id="catAbb" name="catAbb">

					<option value="ccc">all community

					<option value="eee">all event

					<option value="sss">all for sale / wanted

					<option value="ggg">all gigs

					<option value="hhh">all housing
<option disabled value="">--
<option value="hou"> apts wanted
<option value="apa" selected> apts/housing for rent
<option value="swp"> housing swap
<option value="hsw"> housing wanted
<option value="off"> office &amp; commercial
<option value="prk"> parking &amp; storage
<option value="reb"> real estate - by broker
<option value="reo"> real estate - by owner
<option value="rea"> real estate for sale
<option value="rew"> real estate wanted
<option value="roo"> rooms &amp; shares
<option value="sha"> rooms wanted
<option value="sbw"> sublet/temp wanted
<option value="sub"> sublets &amp; temporary
<option value="vac"> vacation rentals
<option disabled value="">--

					<option value="jjj">all jobs

					<option value="ppp">all personals

					<option value="res">all resume

					<option value="bbb">all services offered
</select>
				<input type="submit" value="Search">
				<label>
					<input type="radio" name="srchType" value="T"
					title="search only posting titles">title
				</label>
				<label>
					<input type="radio" name="srchType" value="A" checked="checked"
					title="search the entire posting">entire post
				</label>
			</td>
		</tr>

		<tr>
			<td align="right">rent:</td>
			<td><input name="minAsk" class="min" size="5" value="">
<input name="maxAsk" class="max" size="5" value="">

<select name="bedrooms">
	<option value="">0+ BR</option>
<option value="1">1 BR</option>
<option value="2">2+ BR</option>
<option value="3">3+ BR</option>
<option value="4">4+ BR</option>
<option value="5">5+ BR</option>
<option value="6">6+ BR</option>
<option value="7">7+ BR</option>
<option value="8">8+ BR</option>

</select>
<label>
	<input type="checkbox" name="addTwo"  value="purrr">cats
</label>
<label>
	<input type="checkbox" name="addThree" value="wooof">dogs
</label>

				<span id="hoodpicker"></span>
				<label>
					<input type="checkbox" name="hasPic" value="1">has image
				</label>
			</td>
		</tr>
	</table>
    </fieldset>
</form>
</blockquote>


		<section class="body">
			<blockquote id="messagetable"><div id="messages"><span class="hl"> [ <a href="/forums/?forumID=6">housing forum</a> ]</span>
<span class="hl"> [ <a href="/about/FHA">fair housing</a> ] </span>
<span class="hl"> [ <a href="https://action.eff.org/o/9042/p/dia/action/public/?action_KEY=9048">Pro Privacy? Oppose CISPA</a> ] </span>
<span class="hl"> [ <a href="http://eff.org">EFF</a> ] </span>
<span class="hl"> [ <b><a href="/about/scams">AVOIDING SCAMS</a></b> ] </span>
<span class="hl"> [ <b><a href="/about/safety">PERSONAL SAFETY</a></b> ] </span>
<span class="hl"> [ <a href="http://youtube.com/craigslist">CL {tv}</a> ] </span>
<span class="hl"> [ <a href="http://blog.craigslist.org/">blog</a> ] </span>
</div></blockquote>
			
			

			<blockquote class="modebtns v">
	<button id="listview">list view</button>
	<button id="picview">pic view</button>
	<button id="gridview">grid view</button>
	<button id="mapview">map view</button>
</blockquote>


			<blockquote id="toc_rows">

			<h4 class="ban">Mon Apr 15</h4>
 <p class="row" data-pid="3745056214"> <a href="http://burlington.craigslist.org/apa/3745056214.html"> <span class="i" data-id="3Ge3Fe3J95L15G25M1d4f8e774a9d0e171122.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3745056214"></span>
  <a href="http://burlington.craigslist.org/apa/3745056214.html">work/housing exchange on small farm</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1</span>  <span class="itempp"></span> <small> (Brattleboro area)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.355690" data-longitude="-72.557431" data-pid="3686725511"> <a href="http://burlington.craigslist.org/apa/3686725511.html"> <span class="i" data-id="3G83me3J25Ie5L45Ead3hd440d57401a21b0f.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3686725511"></span>
  <a href="http://burlington.craigslist.org/apa/3686725511.html">Worcester House for Rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1600</span> / 4br - 1800ft&sup2; -  <span class="itempp"></span> <small> (1 mile from Putnamville)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3686725511">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.468486" data-longitude="-73.170953" data-pid="3686789891"> <a href="http://burlington.craigslist.org/apa/3686789891.html"> <span class="i" data-id="3Ea3G63K85Ne5Ge5F1d3hb7c72b69b15315e2.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3686789891"></span>
  <a href="http://burlington.craigslist.org/apa/3686789891.html">Small 1 bedroom</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$650</span> / 1br -  <span class="itempp"></span> <small> (190 White St. South Burlington)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3686789891">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.481515" data-longitude="-73.206910" data-pid="3732078183"> <a href="http://burlington.craigslist.org/apa/3732078183.html"> <span class="i" data-id="3Kf3Ff3Lb5I55Hf5Mad48c3a7f5cde27b19a9.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3732078183"></span>
  <a href="http://burlington.craigslist.org/apa/3732078183.html">Students: House for rent, close to UVM campus and downtown-Isham Stree</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$4200</span> / 6br -  <span class="itempp"></span> <small> (Isham Street)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3732078183">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.491372" data-longitude="-73.186452" data-pid="3744717426"> <a href="http://burlington.craigslist.org/apa/3744717426.html"> <span class="i" data-id="3K73If3F35Gc5Hc5M1d4f96de992d89fd13f6.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744717426"></span>
  <a href="http://burlington.craigslist.org/apa/3744717426.html">LARGE MODERN CLEAN</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$875</span> / 1br - 650ft&sup2; -  <span class="itempp"></span> <small> (Burlington/Winooski)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3744717426">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744716308"> <a href="http://burlington.craigslist.org/apa/3744716308.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744716308"></span>
  <a href="http://burlington.craigslist.org/apa/3744716308.html">Small 2 bedroom apartment for rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$625</span> / 2br - 700ft&sup2; -  <span class="itempp"></span> <small> (Claremont)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744675921"> <a href="http://burlington.craigslist.org/apa/3744675921.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744675921"></span>
  <a href="http://burlington.craigslist.org/apa/3744675921.html"> apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$600</span> / 1br - 1000ft&sup2; -  <span class="itempp"></span> <small> (castleton, vermont)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744652754"> <a href="http://burlington.craigslist.org/apa/3744652754.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744652754"></span>
  <a href="http://burlington.craigslist.org/apa/3744652754.html">Three Bedroom apartment available now!!!</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$850</span> / 3br -  <span class="itempp"></span> <small> (Bellows Falls, Vermont)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744540050"> <a href="http://burlington.craigslist.org/apa/3744540050.html"> <span class="i" data-id="3E83Mf3N15N45H15J1d4ff5b49a7934101708.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744540050"></span>
  <a href="http://burlington.craigslist.org/apa/3744540050.html">2 BR Arbor Gardens</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1054</span> / 2br - 856ft&sup2; -  <span class="itempp"></span> <small> (Colchester)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.534160" data-longitude="-72.007465" data-pid="3744539927"> <a href="http://burlington.craigslist.org/apa/3744539927.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744539927"></span>
  <a href="http://burlington.craigslist.org/apa/3744539927.html">lyndonville, Vt.</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$600</span> / 2br - 1000ft&sup2; -  <span class="itempp"></span> <small> (Center St.)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3744539927">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.542970" data-longitude="-72.000639" data-pid="3735064246"> <a href="http://burlington.craigslist.org/apa/3735064246.html"> <span class="i" data-id="3M13Na3Hd5N45G15J8d4a62e22c505efe182a.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3735064246"></span>
  <a href="http://burlington.craigslist.org/apa/3735064246.html">New ground floor heat included</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$625</span> / 1br -  <span class="itempp"></span> <small> (Lyndonville)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3735064246">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.463350" data-longitude="-73.188643" data-pid="3744486754"> <a href="http://burlington.craigslist.org/apa/3744486754.html"> <span class="i" data-id="3G23Id3H95L85Hb5J7d4f436a9a9a918d147e.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744486754"></span>
  <a href="http://burlington.craigslist.org/apa/3744486754.html">Condo Close to UVM &amp; Flecher Allen</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 2br -  <span class="itempp"></span> <small> (Quarry Hil)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3744486754">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744462955"> <a href="http://burlington.craigslist.org/apa/3744462955.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744462955"></span>
  <a href="http://burlington.craigslist.org/apa/3744462955.html">Large apartment - Convenient</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$450</span> / 1br -  <span class="itempp"></span> <small> (Castleton)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744441500"> <a href="http://burlington.craigslist.org/apa/3744441500.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744441500"></span>
  <a href="http://burlington.craigslist.org/apa/3744441500.html">Sunny Burlington  apt.</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 2br -  <span class="itempp"></span> <small> (Oak St.)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.473591" data-longitude="-73.215432" data-pid="3744439499"> <a href="http://burlington.craigslist.org/apa/3744439499.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744439499"></span>
  <a href="http://burlington.craigslist.org/apa/3744439499.html">Fantastic Location</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1400</span> / 2br -  <span class="itempp"></span> <small> (224 Pine St.)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3744439499">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.975162" data-longitude="-73.373521" data-pid="3744438123"> <a href="http://burlington.craigslist.org/apa/3744438123.html"> <span class="i" data-id="3Gc3F73Ie5L65K55H9d4f461b583bdc921b55.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744438123"></span>
  <a href="http://burlington.craigslist.org/apa/3744438123.html">Two Bedroom Condo</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$775</span> / 2br - 1200ft&sup2; -  <span class="itempp"></span> <small> (Rouses Point, NY)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3744438123">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744429417"> <a href="http://burlington.craigslist.org/apa/3744429417.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744429417"></span>
  <a href="http://burlington.craigslist.org/apa/3744429417.html">South End June 1rst </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1400</span> / 2br -  <span class="itempp"></span> <small> (Howard )</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.623098" data-longitude="-73.130579" data-pid="3720183785"> <a href="http://burlington.craigslist.org/apa/3720183785.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3720183785"></span>
  <a href="http://burlington.craigslist.org/apa/3720183785.html">2 Bed 1.5 Bath </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1000</span> / 2br -  <span class="itempp"></span>  <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3720183785">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744413507"> <a href="http://burlington.craigslist.org/apa/3744413507.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744413507"></span>
  <a href="http://burlington.craigslist.org/apa/3744413507.html">Third floor</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$475</span> / 1br -  <span class="itempp"></span> <small> (St. Johnsbury)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.471506" data-longitude="-73.191090" data-pid="3691508056"> <a href="http://burlington.craigslist.org/apa/3691508056.html"> <span class="i" data-id="3Ec3M13J35Nb5Ef5J3d3j1224ee8a3d8715fb.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3691508056"></span>
  <a href="http://burlington.craigslist.org/apa/3691508056.html">2 rooms available June 1st ($525)</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$525</span> / 110ft&sup2; -  <span class="itempp"></span> <small> (3 East Terrace, South Burlington)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3691508056">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3717146939"> <a href="http://burlington.craigslist.org/apa/3717146939.html"> <span class="i" data-id="3I33M83Jc5Ia5M45J3d41f3bdb40252e01074.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3717146939"></span>
  <a href="http://burlington.craigslist.org/apa/3717146939.html">Walk to Downtown</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$925</span> / 2br -  <span class="itempp"></span> <small> (Brattleboro)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.153216" data-longitude="-72.841505" data-pid="3744353619"> <a href="http://burlington.craigslist.org/apa/3744353619.html"> <span class="i" data-id="3E63La3F55Ee5He5Med4e8a818c3dba801db8.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744353619"></span>
  <a href="http://burlington.craigslist.org/apa/3744353619.html">One Bedroom near Sugarbush</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$650</span> / 1br - 900ft&sup2; -  <span class="itempp"></span> <small> (Waitsfield Vt )</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3744353619">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744313938"> <a href="http://burlington.craigslist.org/apa/3744313938.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744313938"></span>
  <a href="http://burlington.craigslist.org/apa/3744313938.html">Burlington four bedroom apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2000</span> / 4br - 1100ft&sup2; -  <span class="itempp"></span> <small> (9 Chase Street Burlington, Vt 05401)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.975100" data-longitude="-72.699000" data-pid="3744311447"> <a href="http://burlington.craigslist.org/apa/3744311447.html"> <span class="i" data-id="3K13Je3N35N55La5Hfd4fb2c37f4ff1921895.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744311447"></span>
  <a href="http://burlington.craigslist.org/apa/3744311447.html">Fresh 2 bedroom 2.5 bathroom in Richford</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$900</span> / 2br - 1125ft&sup2; -  <span class="itempp"></span> <small> (Richford)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3744311447">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744307275"> <a href="http://burlington.craigslist.org/apa/3744307275.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744307275"></span>
  <a href="http://burlington.craigslist.org/apa/3744307275.html">Burlington 3 bedroom apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1500</span> / 3br - 900ft&sup2; -  <span class="itempp"></span> <small> (9 Chase Street Burlington, Vt 05401)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744299876"> <a href="http://burlington.craigslist.org/apa/3744299876.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744299876"></span>
  <a href="http://burlington.craigslist.org/apa/3744299876.html">Burlington 3 bedroom apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1800</span> / 3br - 750ft&sup2; -  <span class="itempp"></span> <small> (79 Spruce Street Burlington Vt 05401)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.811100" data-longitude="-73.089000" data-pid="3744279503"> <a href="http://burlington.craigslist.org/apa/3744279503.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744279503"></span>
  <a href="http://burlington.craigslist.org/apa/3744279503.html">Bright and Sunny 1 bedroom in quiet family neighborhood</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$875</span> / 1br -  <span class="itempp"></span> <small> (st.albans)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3744279503">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3744118144"> <a href="http://burlington.craigslist.org/apa/3744118144.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3744118144"></span>
  <a href="http://burlington.craigslist.org/apa/3744118144.html">Seeking rental house in country that allows pets</a> </span> </span> <span class="title2"> <span class="itempnr">  <span class="itempp"></span> <small> (Southern/Central VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
<h4 class="ban">Sun Apr 14</h4>
 <p class="row" data-pid="3743994352"> <a href="http://burlington.craigslist.org/apa/3743994352.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743994352"></span>
  <a href="http://burlington.craigslist.org/apa/3743994352.html">Nice views and private yard</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$650</span> / 3br - 1500ft&sup2; -  <span class="itempp"></span> <small> (Londonderry VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3743932836"> <a href="http://burlington.craigslist.org/apa/3743932836.html"> <span class="i" data-id="3Fa3Jb3Nf5I45G95Edd4e12880fc5bcf2170b.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743932836"></span>
  <a href="http://burlington.craigslist.org/apa/3743932836.html">Contemporary Post &amp; Beam Farmhouse </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2200</span> / 5br - 3500ft&sup2; -  <span class="itempp"></span> <small> (Bridport, VT)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3727827609"> <a href="http://burlington.craigslist.org/apa/3727827609.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3727827609"></span>
  <a href="http://burlington.craigslist.org/apa/3727827609.html">house for rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1100</span> / 1br -  <span class="itempp"></span> <small> (sheldon,vt)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3711569119"> <a href="http://burlington.craigslist.org/apa/3711569119.html"> <span class="i" data-id="3E13F23M55N25Gf5K7d3t86ceeec4f2c91a2d.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3711569119"></span>
  <a href="http://burlington.craigslist.org/apa/3711569119.html">Green Living, fun, funky apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 3br - 1000ft&sup2; -  <span class="itempp"></span> <small> (downtown Johnson)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.394274" data-longitude="-72.692628" data-pid="3743742420"> <a href="http://burlington.craigslist.org/apa/3743742420.html"> <span class="i" data-id="3G63M13I35L75I45Kcd4e9de1d5a562d3181c.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743742420"></span>
  <a href="http://burlington.craigslist.org/apa/3743742420.html">Ludlow One Bedroom</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$520</span> / 1br -  <span class="itempp"></span> <small> (75-77 Pleasant St)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3743742420">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.053753" data-longitude="-72.535644" data-pid="3743661139"> <a href="http://burlington.craigslist.org/apa/3743661139.html"> <span class="i" data-id="3Ed3F33Mb5N85Ed5Kfd4e0e4bdb18e3f6188e.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743661139"></span>
  <a href="http://burlington.craigslist.org/apa/3743661139.html">available July or Sept: Bright, open floor plan: top of the world</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1250</span> / 3br - 1300ft&sup2; -  <span class="itempp"></span> <small> (Chelsea, VT)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3743661139">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3743621136"> <a href="http://burlington.craigslist.org/apa/3743621136.html"> <span class="i" data-id="3Kf3M13N45G15E75M4d4e136d6d093dc61519.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743621136"></span>
  <a href="http://burlington.craigslist.org/apa/3743621136.html">Charming 3br house.  Avail May 1st.</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1000</span> / 3br - 1300ft&sup2; -  <span class="itempp"></span> <small> (West Road Bennington, VT)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.135290" data-longitude="-73.080094" data-pid="3743590521"> <a href="http://burlington.craigslist.org/apa/3743590521.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743590521"></span>
  <a href="http://burlington.craigslist.org/apa/3743590521.html">Sunny 1 Bedroom </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$700</span> / 1br - 500ft&sup2; -  <span class="itempp"></span> <small> (Bristol Village)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3743590521">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.482943" data-longitude="-73.209586" data-pid="3743478449"> <a href="http://burlington.craigslist.org/apa/3743478449.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743478449"></span>
  <a href="http://burlington.craigslist.org/apa/3743478449.html">3 Bedroom at 85 North Union</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$691</span> / 3br -  <span class="itempp"></span> <small> (85 North Union)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3743478449">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.996525" data-longitude="-72.402804" data-pid="3689701654"> <a href="http://burlington.craigslist.org/apa/3689701654.html"> <span class="i" data-id="3G93Ia3J45Eb5F85Jad3i538493cb5b771320.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3689701654"></span>
  <a href="http://burlington.craigslist.org/apa/3689701654.html">Spacious and Recently Renovated</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$800</span> / 1br -  <span class="itempp"></span> <small> (North Troy)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3689701654">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.996525" data-longitude="-72.402804" data-pid="3689761112"> <a href="http://burlington.craigslist.org/apa/3689761112.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3689761112"></span>
  <a href="http://burlington.craigslist.org/apa/3689761112.html">Newly Renovated, 2 Bedrooms, 2 Bathrooms</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$800</span> / 2br -  <span class="itempp"></span> <small> (North Troy, VT)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3689761112">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.451796" data-longitude="-73.108435" data-pid="3743259598"> <a href="http://burlington.craigslist.org/apa/3743259598.html"> <span class="i" data-id="3L33F23H95L45I15F6d4ee52947b9e4b31c80.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743259598"></span>
  <a href="http://burlington.craigslist.org/apa/3743259598.html">2 Bedroom  1 Bath, New Building</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1500</span> / 2br - 1100ft&sup2; -  <span class="itempp"></span> <small> (Williston)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3743259598">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3743170175"> <a href="http://burlington.craigslist.org/apa/3743170175.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743170175"></span>
  <a href="http://burlington.craigslist.org/apa/3743170175.html">Chase St 2brm avail June 1</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 2br -  <span class="itempp"></span> <small> (Burlington)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3743135186"> <a href="http://burlington.craigslist.org/apa/3743135186.html"> <span class="i" data-id="3Ef3L83I95G55Eb5M2d4e52fddd92e1d316ba.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743135186"></span>
  <a href="http://burlington.craigslist.org/apa/3743135186.html">Very Nice Furnished Condo for Short Term Rent -- UTILITIES INCLUDED!!! </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1600</span> / 2br -  <span class="itempp"></span> <small> (South Burlington, VT )</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3743058240"> <a href="http://burlington.craigslist.org/apa/3743058240.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743058240"></span>
  <a href="http://burlington.craigslist.org/apa/3743058240.html">Cabin / land for aspiring farmers</a> </span> </span> <span class="title2"> <span class="itempnr">  <span class="itempp"></span> <small> (Brookline VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.811100" data-longitude="-73.089000" data-pid="3743002113"> <a href="http://burlington.craigslist.org/apa/3743002113.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3743002113"></span>
  <a href="http://burlington.craigslist.org/apa/3743002113.html">Large Sunny apartment in quiet family neighborhood</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$875</span> / 1br -  <span class="itempp"></span> <small> (st.albans)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3743002113">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.592051" data-longitude="-72.966470" data-pid="3697460322"> <a href="http://burlington.craigslist.org/apa/3697460322.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3697460322"></span>
  <a href="http://burlington.craigslist.org/apa/3697460322.html">Apartment for Rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$700</span> / 1br -  <span class="itempp"></span> <small> (Rutland, VT)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3697460322">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.474078" data-longitude="-73.215294" data-pid="3742922520"> <a href="http://burlington.craigslist.org/apa/3742922520.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742922520"></span>
  <a href="http://burlington.craigslist.org/apa/3742922520.html">4BR- Downtown Burlington</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2300</span> / 4br -  <span class="itempp"></span> <small> (188 Pine St)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3742922520">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.995793" data-longitude="-72.669505" data-pid="3742914444"> <a href="http://burlington.craigslist.org/apa/3742914444.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742914444"></span>
  <a href="http://burlington.craigslist.org/apa/3742914444.html">Home for rent in Richford </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$725</span> / 2br - 1000ft&sup2; -  <span class="itempp"></span> <small> (Richford)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3742914444">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.465914" data-longitude="-73.207699" data-pid="3727412326"> <a href="http://burlington.craigslist.org/apa/3727412326.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3727412326"></span>
  <a href="http://burlington.craigslist.org/apa/3727412326.html">1st floor 2 bedroom apt</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1595</span>  <span class="itempp"></span> <small> (burlington)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3727412326">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.451673" data-longitude="-73.109121" data-pid="3742811842"> <a href="http://burlington.craigslist.org/apa/3742811842.html"> <span class="i" data-id="3K93Id3N35N55Ea5Mdd4e3d06722546e11b66.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742811842"></span>
  <a href="http://burlington.craigslist.org/apa/3742811842.html">Nice 2 Bed/ 1 Bath Units</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1375</span> / 2br - 1000ft&sup2; -  <span class="itempp"></span> <small> (Williston)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3742811842">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.182548" data-longitude="-72.870877" data-pid="3742806670"> <a href="http://burlington.craigslist.org/apa/3742806670.html"> <span class="i" data-id="3G93Mf3Nb5N15F35M9d4g0e36be59c60915ea.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742806670"></span>
  <a href="http://burlington.craigslist.org/apa/3742806670.html">Large two bedroom apt - furnished</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1000</span> / 2br - 1400ft&sup2; -  <span class="itempp"></span> <small> (Waitsfield)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3742806670">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.168754" data-longitude="-72.818413" data-pid="3736477425"> <a href="http://burlington.craigslist.org/apa/3736477425.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3736477425"></span>
  <a href="http://burlington.craigslist.org/apa/3736477425.html">Artist Loft Studio Industrial Space</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$400</span> / 1200ft&sup2; -  <span class="itempp"></span> <small> (Londonderry Vermont)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3736477425">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.484000" data-longitude="-73.219900" data-pid="3742763856"> <a href="http://burlington.craigslist.org/apa/3742763856.html"> <span class="i" data-id="3Ed3M73J35I85K55F6d4e04b36fb9163c18b3.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742763856"></span>
  <a href="http://burlington.craigslist.org/apa/3742763856.html">JUNE 1ST DOWNTOWN STUDIO JUST RENOVATED</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$875</span>  <span class="itempp"></span> <small> (52 NO WINOSKI AVE)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3742763856">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.760223" data-longitude="-73.065266" data-pid="3707626682"> <a href="http://burlington.craigslist.org/apa/3707626682.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3707626682"></span>
  <a href="http://burlington.craigslist.org/apa/3707626682.html">Heat &amp; Electricity Included</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1050</span> / 2br -  <span class="itempp"></span> <small> (Main Street, Fairfax)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3707626682">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3742628435"> <a href="http://burlington.craigslist.org/apa/3742628435.html"> <span class="i" data-id="3E63G23Hd5Lf5H55J2d4eeb638cbc707a1de5.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742628435"></span>
  <a href="http://burlington.craigslist.org/apa/3742628435.html">Studio Condo near Toll House</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$750</span> / 400ft&sup2; -  <span class="itempp"></span> <small> (Stowe)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3742613016"> <a href="http://burlington.craigslist.org/apa/3742613016.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742613016"></span>
  <a href="http://burlington.craigslist.org/apa/3742613016.html">Beautiful condo for rent on month to month basis starting May 1, 2013.</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1400</span> / 2br -  <span class="itempp"></span> <small> (100 W Canal St, #17, Winooski, VT 05404)</small> <span class="itempx"> <span class="p"> img</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3683017257"> <a href="http://burlington.craigslist.org/apa/3683017257.html"> <span class="i" data-id="3E43Kd3M35N45E75F9d4e72697cce31451936.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3683017257"></span>
  <a href="http://burlington.craigslist.org/apa/3683017257.html">house rental ,wilmington</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1950</span> / 4br - 4500ft&sup2; -  <span class="itempp"></span> <small> (wilmington)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3742558765"> <a href="http://burlington.craigslist.org/apa/3742558765.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742558765"></span>
  <a href="http://burlington.craigslist.org/apa/3742558765.html">small home for rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$700</span> / 1br - 500ft&sup2; -  <span class="itempp"></span> <small> (st. albans )</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3717472375"> <a href="http://burlington.craigslist.org/apa/3717472375.html"> <span class="i" data-id="3G23Kd3Fd5N65K75F2d410219a08fd6351afe.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3717472375"></span>
  <a href="http://burlington.craigslist.org/apa/3717472375.html">2 BD Condo Includes heat Highland Meadows</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$850</span> / 2br - 800ft&sup2; -  <span class="itempp"></span> <small> (Rutland)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
<h4 class="ban">Sat Apr 13</h4>
 <p class="row" data-pid="3742272594"> <a href="http://burlington.craigslist.org/apa/3742272594.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742272594"></span>
  <a href="http://burlington.craigslist.org/apa/3742272594.html">Room to rent in E.Montpelier Home</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$500</span>  <span class="itempp"></span> <small> (DO NOT RENT!!)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.612030" data-longitude="-73.175812" data-pid="3742227215"> <a href="http://burlington.craigslist.org/apa/3742227215.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742227215"></span>
  <a href="http://burlington.craigslist.org/apa/3742227215.html">4 Bedroom Center of Castleton</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1400</span> / 4br - 1350ft&sup2; -  <span class="itempp"></span> <small> (Castleton College)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3742227215">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3720668127"> <a href="http://burlington.craigslist.org/apa/3720668127.html"> <span class="i" data-id="3Eb3Gf3H45G75Kc5H5d43a8e08d2a59011e21.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3720668127"></span>
  <a href="http://burlington.craigslist.org/apa/3720668127.html">Bomoseen Lakefront apt for rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$700</span> / 1br -  <span class="itempp"></span> <small> (Bomoseen, VT)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3683264229"> <a href="http://burlington.craigslist.org/apa/3683264229.html"> <span class="i" data-id="3nd3J73Ha5N25Ie5Lfd3f09ab2624a5b61013.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3683264229"></span>
  <a href="http://burlington.craigslist.org/apa/3683264229.html">3bdrm lakefront home -perfect for family or roomates</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1300</span> / 3br -  <span class="itempp"></span> <small> (Lake Bomoseen, VT (rt 30))</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3742033884"> <a href="http://burlington.craigslist.org/apa/3742033884.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3742033884"></span>
  <a href="http://burlington.craigslist.org/apa/3742033884.html">Vt. home on 2 acres</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1100</span> / 4br -  <span class="itempp"></span> <small> (Brookline)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741946196"> <a href="http://burlington.craigslist.org/apa/3741946196.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741946196"></span>
  <a href="http://burlington.craigslist.org/apa/3741946196.html">CONDO   FURNISHED OR UNFURNISHED</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 2br -  <span class="itempp"></span> <small> (MONTPELIER,FREEDOM DRIVE)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741943891"> <a href="http://burlington.craigslist.org/apa/3741943891.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741943891"></span>
  <a href="http://burlington.craigslist.org/apa/3741943891.html">heat &amp; hot water &amp; storage</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$950</span> / 2br -  <span class="itempp"></span> <small> (white river jct)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741904774"> <a href="http://burlington.craigslist.org/apa/3741904774.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741904774"></span>
  <a href="http://burlington.craigslist.org/apa/3741904774.html">first floor apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$800</span> / 1br -  <span class="itempp"></span> <small> (BARRE,ANDREWS COURT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741890017"> <a href="http://burlington.craigslist.org/apa/3741890017.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741890017"></span>
  <a href="http://burlington.craigslist.org/apa/3741890017.html">second floor apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$950</span> / 2br -  <span class="itempp"></span> <small> (MONTPELIER,BARRE STREET)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741877418"> <a href="http://burlington.craigslist.org/apa/3741877418.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741877418"></span>
  <a href="http://burlington.craigslist.org/apa/3741877418.html">SECOND FLOOR APARTMENT</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$695</span> / 3br -  <span class="itempp"></span> <small> (BARRE,MAPLE AVENUE)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741834440"> <a href="http://burlington.craigslist.org/apa/3741834440.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741834440"></span>
  <a href="http://burlington.craigslist.org/apa/3741834440.html">Luxury condo</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 1br -  <span class="itempp"></span> <small> (burlington)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741831507"> <a href="http://burlington.craigslist.org/apa/3741831507.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741831507"></span>
  <a href="http://burlington.craigslist.org/apa/3741831507.html">hardwood floors in excellent condition</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$999</span> / 1br -  <span class="itempp"></span> <small> (south burlington)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741828926"> <a href="http://burlington.craigslist.org/apa/3741828926.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741828926"></span>
  <a href="http://burlington.craigslist.org/apa/3741828926.html">newly renovate</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1100</span> / 1br -  <span class="itempp"></span> <small> (Barrett St APT C, Burlington, VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741819980"> <a href="http://burlington.craigslist.org/apa/3741819980.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741819980"></span>
  <a href="http://burlington.craigslist.org/apa/3741819980.html">Features Clothes Washer/Dryer/Fridg</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$900</span> / 1br -  <span class="itempp"></span> <small> (Dorr Drive, Rutland City, VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741818065"> <a href="http://burlington.craigslist.org/apa/3741818065.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741818065"></span>
  <a href="http://burlington.craigslist.org/apa/3741818065.html">Unique and spacious one bedroom</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$990</span> / 1br -  <span class="itempp"></span> <small> ( Main St ,Colchester VT)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.500423" data-longitude="-73.151779" data-pid="3741662657"> <a href="http://burlington.craigslist.org/apa/3741662657.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741662657"></span>
  <a href="http://burlington.craigslist.org/apa/3741662657.html">CONVENIENT BASEMENT APARTMENT</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$925</span>  <span class="itempp"></span> <small> (RT 15 &amp; 89)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741662657">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.266991" data-longitude="-72.566252" data-pid="3741661783"> <a href="http://burlington.craigslist.org/apa/3741661783.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741661783"></span>
  <a href="http://burlington.craigslist.org/apa/3741661783.html">Close to Town, Good Condition!</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1325</span> / 3br - 1760ft&sup2; -  <span class="itempp"></span> <small> (Montpelier, North Street)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741661783">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.484783" data-longitude="-73.212794" data-pid="3741581022"> <a href="http://burlington.craigslist.org/apa/3741581022.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741581022"></span>
  <a href="http://burlington.craigslist.org/apa/3741581022.html">Heat, Hot Water,Trash removal included</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$900</span> / 1br -  <span class="itempp"></span> <small> (Burlington)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741581022">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.484783" data-longitude="-73.212794" data-pid="3741576197"> <a href="http://burlington.craigslist.org/apa/3741576197.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741576197"></span>
  <a href="http://burlington.craigslist.org/apa/3741576197.html">2 rooms.  Heat/Hot Water included.</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$900</span>  <span class="itempp"></span> <small> (Burlington)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741576197">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741536232"> <a href="http://burlington.craigslist.org/apa/3741536232.html"> <span class="i" data-id="3Fc3M53J25L35K75H5d4dae0970125ce5140d.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741536232"></span>
  <a href="http://burlington.craigslist.org/apa/3741536232.html">nice home on dead end st</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$950</span> / 3br -  <span class="itempp"></span> <small> (windsor)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="42.856305" data-longitude="-72.559698" data-pid="3741523766"> <a href="http://burlington.craigslist.org/apa/3741523766.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741523766"></span>
  <a href="http://burlington.craigslist.org/apa/3741523766.html">Nice large two bedroom in downtown Brattleboro</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$695</span> / 2br - 800ft&sup2; -  <span class="itempp"></span> <small> (Putney Road)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741523766">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="42.986345" data-longitude="-72.655633" data-pid="3741424051"> <a href="http://burlington.craigslist.org/apa/3741424051.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741424051"></span>
  <a href="http://burlington.craigslist.org/apa/3741424051.html">Very Nice apartment in Beautiful Historic Center of Newfane</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$700</span> / 1br -  <span class="itempp"></span> <small> (12 Court St. Newfane)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3741424051">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.493493" data-longitude="-73.184398" data-pid="3741271904"> <a href="http://burlington.craigslist.org/apa/3741271904.html"> <span class="i" data-id="3G53M53J15L25E35K8d4df3ca614544f61f1d.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741271904"></span>
  <a href="http://burlington.craigslist.org/apa/3741271904.html">3 Bedroom, 2 floors, sunny, Eat-in-kitchen, sun porch, W/D</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1650</span> / 3br - 1800ft&sup2; -  <span class="itempp"></span> <small> (Winooski)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3741271904">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741211172"> <a href="http://burlington.craigslist.org/apa/3741211172.html"> <span class="i" data-id="3E13K93F85E95F55Hed4d5fd7d738983b1fe1.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741211172"></span>
  <a href="http://burlington.craigslist.org/apa/3741211172.html">Apartment available</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$850</span> / 1br -  <span class="itempp"></span> <small> (Brattleboro)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741110924"> <a href="http://burlington.craigslist.org/apa/3741110924.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741110924"></span>
  <a href="http://burlington.craigslist.org/apa/3741110924.html">Large Sunny 1 bedroom Apt. Beautiful view</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$925</span> / 1br -  <span class="itempp"></span> <small> (Waterbury Center)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3717643695"> <a href="http://burlington.craigslist.org/apa/3717643695.html"> <span class="i" data-id="3Ed3L33N35L65N25Fad412da0182879811405.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3717643695"></span>
  <a href="http://burlington.craigslist.org/apa/3717643695.html">large furnished room in Redstone Apt, uvm, Burlington, vt</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$600</span> / 1br -  <span class="itempp"></span> <small> (500 South Prospect Street, Burlington)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741018688"> <a href="http://burlington.craigslist.org/apa/3741018688.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741018688"></span>
  <a href="http://burlington.craigslist.org/apa/3741018688.html">upstairs 2 bedroom duplex in country setting</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 2br - 750ft&sup2; -  <span class="itempp"></span> <small> (Richmond)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3741008159"> <a href="http://burlington.craigslist.org/apa/3741008159.html"> <span class="i" data-id="3Kc3L93N85E35Ke5H8d4d4cdadf4734771c5d.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3741008159"></span>
  <a href="http://burlington.craigslist.org/apa/3741008159.html">ski in/ski out condo</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1700</span> / 2br -  <span class="itempp"></span> <small> (Stowe, Vt.)</small> <span class="itempx"> <span class="p"> pic</span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.643281" data-longitude="-72.930851" data-pid="3740997513"> <a href="http://burlington.craigslist.org/apa/3740997513.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740997513"></span>
  <a href="http://burlington.craigslist.org/apa/3740997513.html">1 bedroom apartment,</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$850</span> / 1br - 650ft&sup2; -  <span class="itempp"></span> <small> (Mendon, Vt.)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3740997513">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3731350260"> <a href="http://burlington.craigslist.org/apa/3731350260.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3731350260"></span>
  <a href="http://burlington.craigslist.org/apa/3731350260.html">This place has beach rights and mooring possibilities!</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1100</span> / 2br - 672ft&sup2; -  <span class="itempp"></span> <small> (Colchester)</small> <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.486117" data-longitude="-73.217860" data-pid="3740879277"> <a href="http://burlington.craigslist.org/apa/3740879277.html"> <span class="i" data-id="3Kf3M83H35La5K65Hcd4d6165b0d2f6ab1e20.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740879277"></span>
  <a href="http://burlington.craigslist.org/apa/3740879277.html">Spacious 3 Bedroom Close to Downtown</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1850</span> / 3br - 1083ft&sup2; -  <span class="itempp"></span> <small> (197 N. Champlain Street)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3740879277">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.685129" data-longitude="-73.075047" data-pid="3740872200"> <a href="http://burlington.craigslist.org/apa/3740872200.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740872200"></span>
  <a href="http://burlington.craigslist.org/apa/3740872200.html">Half a House for Rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2000</span> / 1br -  <span class="itempp"></span> <small> (Florence VT)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3740872200">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.477634" data-longitude="-73.203060" data-pid="3702729814"> <a href="http://burlington.craigslist.org/apa/3702729814.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3702729814"></span>
  <a href="http://burlington.craigslist.org/apa/3702729814.html">Burlington College St  apartments for rent 2-5 BR  06/ 2013 ocy</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$750</span> / 5br -  <span class="itempp"></span> <small> (403-407 College street)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3702729814">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.477722" data-longitude="-73.212719" data-pid="3702731037"> <a href="http://burlington.craigslist.org/apa/3702731037.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3702731037"></span>
  <a href="http://burlington.craigslist.org/apa/3702731037.html">5 BR  College St  apartments for rent   5 BR  06/ 2013 ocy</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$750</span> / 5br -  <span class="itempp"></span> <small> (403-407 College street)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3702731037">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.556700" data-longitude="-72.598400" data-pid="3740792391"> <a href="http://burlington.craigslist.org/apa/3740792391.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740792391"></span>
  <a href="http://burlington.craigslist.org/apa/3740792391.html">4 bed 3 bath Available in Morrisville</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1500</span> / 4br - 1775ft&sup2; -  <span class="itempp"></span> <small> (Morrisville)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3740792391">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.485025" data-longitude="-73.186862" data-pid="3740734835"> <a href="http://burlington.craigslist.org/apa/3740734835.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740734835"></span>
  <a href="http://burlington.craigslist.org/apa/3740734835.html">4 Bed, Spacious Apt - Close to UVM</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2200</span> / 4br -  <span class="itempp"></span> <small> (Colchester Ave., Burlington)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3740734835">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="43.606258" data-longitude="-72.970828" data-pid="3740732540"> <a href="http://burlington.craigslist.org/apa/3740732540.html"> <span class="i" data-id="3Ec3Lb3Md5I25E85Hdd4f39c09d2ca3701910.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740732540"></span>
  <a href="http://burlington.craigslist.org/apa/3740732540.html">First Floor Available Now</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$750</span> / 2br -  <span class="itempp"></span> <small> (Rutland)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3740732540">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="42.881200" data-longitude="-72.861300" data-pid="3740709001"> <a href="http://burlington.craigslist.org/apa/3740709001.html"> <span class="i" data-id="3E23K13G25G85F45Jad4d90b8de4be8fb117b.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740709001"></span>
  <a href="http://burlington.craigslist.org/apa/3740709001.html">3 bdrm apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1200</span> / 3br - 2000ft&sup2; -  <span class="itempp"></span> <small> (Rt 100, Wilmington VT)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3740709001">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-pid="3740692343"> <a href="http://burlington.craigslist.org/apa/3740692343.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740692343"></span>
  <a href="http://burlington.craigslist.org/apa/3740692343.html">Highland Village Condo for rent</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$1650</span> / 2br - 1200ft&sup2; -  <span class="itempp"></span>  <span class="itempx"> <span class="p"> </span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="42.884534" data-longitude="-73.180897" data-pid="3740621719"> <a href="http://burlington.craigslist.org/apa/3740621719.html"> <span class="i" data-id="3Ec3K73I45I25L75Mcd4d6bcc1837c6641089.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740621719"></span>
  <a href="http://burlington.craigslist.org/apa/3740621719.html">Second Floor 1 bedroom apartment</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$550</span> / 1br - 650ft&sup2; -  <span class="itempp"></span> <small> (183-2 North Branch St., Bennington, VT)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3740621719">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.811100" data-longitude="-73.089000" data-pid="3740567842"> <a href="http://burlington.craigslist.org/apa/3740567842.html"> <span class="i">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740567842"></span>
  <a href="http://burlington.craigslist.org/apa/3740567842.html">Large sunny 1 bedroom </a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$875</span>  <span class="itempp"></span> <small> (St.albans)</small> <span class="itempx"> <span class="p"> <a href="#" class="maptag" data-pid="3740567842">map</a></span></span> </span>  </span> <br class="c"> </p>
 <p class="row" data-latitude="44.775133" data-longitude="-72.058125" data-pid="3740534169"> <a href="http://burlington.craigslist.org/apa/3740534169.html"> <span class="i" data-id="3G53Lb3H95K85H35M6d4d2f6013f63b981bfa.jpg">&nbsp;</span> </a> <span class="title1"> <span class="pl"> <span class="favstar" title="save this post in your favorites list" data-id="3740534169"></span>
  <a href="http://burlington.craigslist.org/apa/3740534169.html">Northeast Kingdom Home Rental</a> </span> </span> <span class="title2"> <span class="itempnr"> <span class="itemprice">$2000</span> / 5br - 5000ft&sup2; -  <span class="itempp"></span> <small> (Westmore)</small> <span class="itempx"> <span class="p"> pic&nbsp;<a href="#" class="maptag" data-pid="3740534169">map</a></span></span> </span>  </span> <br class="c"> </p>


			<p class="nextpage">
	<a href="index1100.html">next 100 postings</a>
</p>


			<div id="floater">
				<img class="loading" src="http://www.craigslist.org/images/map/animated-spinny.gif">
				<img class="payload" src="http://www.craigslist.org/images/map/animated-spinny.gif">
			</div>
			<div class="loadposting">
				<a href="#" class="full btn">[+]</a> <a href="#" class="close btn">[&ndash;]</a>
				<div class="pleasewait">
					<br>
					<img src="http://www.craigslist.org/favicon.ico" alt="">
					<br>CL<br>
					<img src="http://www.craigslist.org/favicon.ico" alt="">
					<br><br>
				</div>
			</div>

			</blockquote>
		</section>
		
		<ul id="fmtsel">
	<li><b>FORMAT:</b></li>
	<li class="fsel" data-mode="mobile">mobile</li>
	<li class="fsel" data-mode="regular">regular</li>
</ul>

<footer>
	
			<span class="rss">
				<a class="l" href="/apa/index.rss">RSS</a>
				<a href="http://www.craigslist.org/about/rss">(?)</a><br>
			</span>
			
	<ul class="clfooter">
		<li>Copyright &copy; 2013 craigslist, inc.</li>
		<li><a href="//www.craigslist.org/about/terms.of.use">terms of use</a></li>
		<li><a href="//www.craigslist.org/about/privacy_policy">privacy</a></li>
		<li><a href="https://forums.craigslist.org/?forumID=8">feedback</a></li>
		<li><a href="//www.craigslist.org/about/craigslist_is_hiring" style="color: #0b0">CL is hiring</a></li>
	</ul>
</footer>

	</article>
    <script type="text/javascript" src="http://www.craigslist.org/js/jquery-1.7.2.js?v=89700834f1601ac3ebc3e5fb3302c040"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/formats.js?v=6d47c67066549272982d7a06bbb1a291"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/toChecklist.js?v=b163a7aa23a6dad79076f92e56c622f7"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/jquery.form-defaults.js?v=421648d06bad2f29bbfc2f66c5205aeb"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/cookie.js?v=0cce2559d540be0bb52211e4105921c4"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/localstorage.js?v=dc71e9bc7ca6c8ccdc60b33b8b22b699"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/tocs.js?v=ec684caf74fb3deaf3c0ed8810d8839a"></script>
    <script type="text/javascript" src="http://www.craigslist.org/js/postings.js?v=9c55707e0bef2ff648841d09ff0ed11a"></script>

	
    
</body>
</html>
'
p = Parser.new
res = p.findPostings(document)
puts res
	end