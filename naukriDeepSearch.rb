require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'net/http'
require 'watir'
require 'watir-webdriver'

BASE_URL = "http://www.naukri.com/developer-jobs"

EXTRA_URL = "-1"

counter=1

id = 0

def crawler(url,counter,id)

	
	begin
		base_page = Nokogiri::HTML(open(url))
	rescue
		print "Failed to Load Page \n ---------- \n"
		crawler(url,counter,id)
	end
	headliners = base_page.css('.org')
	jobRole = base_page.css('.desig')
	
	exp = base_page.css('.exp')
	
	loc = base_page.css('.loc')
	
	ctc = base_page.css('.salary')
	
	dex = base_page.css('.desc')
	
	
	orgList = []
	
	jrList = []
	expList = []
	locList = []
	ctcList = []
	dexList = []

	headliners.each do |headliner|
	
	  orgList.push(headliner.text)
	 
	 
	end
	
	jobRole.each do |headliner|
	
	  jrList.push(headliner.text)
	 
	 
	end
	
	exp.each do |headliner|
	
	  expList.push(headliner.text)
	 
	 
	end
	
	ctc.each do |headliner|
	
	
	  ctcList.push(headliner.text)
	 
	 
	end
	
	loc.each do |headliner|
	
	  locList.push(headliner.text)
	 
	 
	end
	
	dex.each do |headliner|
	
	  dexList.push((headliner.text).gsub("\n",""))
	 
	 
	end
	
	
	
	
	
	####################################################
	
	email_list = []
	contact_list = []
	contents = base_page.css('.content').map { |link| link['href'] }
	contents.each do |url_depth_1|
		print "\n--------\n"
		print "pulling from :   "
		print url_depth_1
		
		b = Watir::Browser.new
		begin
			b.goto url_depth_1
		rescue
			print "\n\nNo email Found *456\n"
			print "\n----------\n"
			email_list.push(" ")
			b.close
			next
		end
		
		
		begin
			print "\n----------0\n"
			b.link(:id => 'viewCont_trg').click
			print "\n----------1\n"
			
			
			
			contact_div = b.div(:id =>'viewContact').when_present.image
			print "\n----------2\n"
			email =  contact_div.title
			print "\n----------3\n"
			print email
			
			print "\n----------\n"
			email_list.push(email)
			print "\n----------*****\n"
			print "\nEMAIL FOUNd  :  " + email + "\n" 
			print "\n----------*****\n"
		rescue
			print "\n\nNo email Found  * 637\n\n"
			print "\n----------\n"
			email_list.push(" ")
		end
		
		
		
		begin
			print "\n****************************\n"
			
			contact_details =  b.div(:id =>'viewContact').text
			print 1
			print contact_details
			print 2
			contact_list.push(contact_details)
			
			print "\n**********************\n"
		
		rescue
			contact_list.push(" ")
			
		end
		
		
		
		b.close
    end
	
	#################################################################################

	CSV.open("myfile.csv", "ab") do |csv|
		i = 0
		while i <50  do
			
			print "--------------"
			print jrList[i]
			print "\n"
			print orgList[i]
			print "\n"
			print locList[i]
			print "\n"
			print ctcList[i]
			print "\n"
			print dexList[i]
			print "\n"
			print email_list[i]
			print "\n"
			print contact_list[i]
			print "\n"
			print counter
			print "\n"
			
		
			begin
				csv << [jrList[i],orgList[i],expList[i],locList[i],ctcList[i].to_i,dexList[i],email_list[i],contact_list[i],counter]
			rescue
				csv << [jrList[i],orgList[i],expList[i],locList[i],ctcList[i],dexList[i],email_list[i],contact_list[i],counter]
			end

			i = i+1
		end
		
	end
	
	
	if counter <1000
		counter = counter + 1
		start_url = BASE_URL+"-"+counter.to_s
		crawler start_url,counter,id
	end

	
end

start_url = BASE_URL+EXTRA_URL
crawler start_url,counter,id
	



