require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'net/http'
require 'watir'
require "mechanize"
require 'write_xlsx'



BASE_URL = "http://resultsarchives.nic.in/cbseresults/cbseresults2010/class10/cbse10.htm"

EXTRA_URL = ""

$studentDetails = []
$masterKey = []
#4135044   ---- 1
#4135544   ---- 2
$counter=4145041



id = 0

def crawler(url,id)

	
	begin
		base_page = Nokogiri::HTML(open(url))
	rescue
		print "Failed to Load Page \n ---------- \n"
		crawler(url,id)
	end

	agent = Mechanize.new
	page = agent.get(url)


	begin
		loggedin_page = page.form do |form|
			regno = form.field_with(:name => 'regno')
	    		regno.value = $counter
		end.submit

		doc = Nokogiri::HTML(loggedin_page.body, "UTF-8")
		info = doc.xpath('//table')[4]
		marks = doc.xpath('//table')[5]

	rescue
		$counter = $counter + 1
		crawler(url,id)
	end

	

	flag = 1
	switcher = 0
	lineSkipper = 0
	key = ''

	student = {}
	weirdSkipper = 0
	weirdSkipperCount = 0

	marks.xpath('//td').each do |node|
		
		  if weirdSkipper == 1
			
			if weirdSkipperCount == 0
				weirdSkipperCount = weirdSkipperCount + 1
				next
			end

			if weirdSkipperCount == 3
				weirdSkipperCount = 0
				next
			end
		  end 

	          if node.text == "SUB CODE"
			next
		  end 

		  if node.text == "SUB NAME"
			next
		  end 

		  if node.text == "GRADE"
			next
		  end

		  if node.text == "GRADE POINT"
			weirdSkipper = 1
			next
		  end 

		  if node.text == 'Roll No:'
			flag = 0 
		
		  end
		  if flag == 0
			if switcher == 1
				student[key] = node.text
				switcher = 0
				lineSkipper = 1
			end

			if switcher == 0 and lineSkipper == 0
				key = node.text.delete(' ')
				key = key.delete(":")
				key = key.delete("'")
				switcher = 1
			end

			lineSkipper = 0
		  end

		  if node.text.include? "CGPA"
		 
			flag = 1
		  end
	end

	

	$studentDetails << student


	if $studentDetails.size >= 500
		printer()

		$studentDetails = []
		$masterKey = []

	end

	print $studentDetails.size


	if $studentDetails.size < 500

		$counter = $counter + 1
		crawler(url,id)
	end


end

def printer()

	$studentDetails.each do |student|
	
		student.keys.each do |key|
			if $masterKey.include? key
				next
			end

			$masterKey << key
		end	

			
		
	end

	keyHash = {}

	$masterKey.each_with_index do |m,index|
		keyHash[m] = index
	end


	$studentDetails.each do |student|
		print "\n########################################\n"
		print student
		print "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n"
	end

	print "\n"
	print keyHash

	
	# Create a new Excel workbook
        workbook = WriteXLSX.new($counter.to_s+'.xlsx')


	# Add a worksheet
	worksheet = workbook.add_worksheet


	keyHash.each do |k|
		worksheet.write(0,k[1],k[0])
	end 


	row_index = 1


	$studentDetails.each do |student|

		student.each do |cell|
			worksheet.write(row_index,keyHash[cell[0]],cell[1])
		end

		row_index = row_index +1 

	end


	workbook.close
	

end


start_url = BASE_URL+EXTRA_URL
crawler start_url,id
	



