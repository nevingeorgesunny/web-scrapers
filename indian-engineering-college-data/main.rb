require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

BASE_URL = "http://www.engineering.careers360.com"

EXTRA_URL = "/colleges/list-of-engineering-colleges-in-India"

def crawler(url)

	base_page = Nokogiri::HTML(open(url))
	contents = base_page.css('div#content li') 
	count = 0
	entry = 1
	contents.each do |content|

		inner_contents = content.css('div')
		content_id = 0
		college_name = nil
		college_url = nil
		college_location = nil
		college_est = nil
		college_contact_number = nil
		college_type = nil
		inner_contents.each do |inner_content|
			
			if inner_content['class'] !~ /fieldAtt/ &&
				inner_content['class'] !~ /write-review/ &&
				inner_content['class'] !~ /content-box f-right/ &&
				inner_content['class'] !~ /btnBlock/ &&
				inner_content['class'] !~ /sponsored-img/ &&
				inner_content['class'] !~ /image-box f-left/
				
					puts inner_content.text
					puts "   "

					if inner_content['class'] == "title"
						college_name = inner_content.text
					end

					if inner_content['class'] == "clg-state clgAtt"
						college_location = inner_content.css('a')
						college_location = college_location.text
						puts college_location
					end
					
					if inner_content['class'] == "clg-url clgAtt"
						college_url = inner_content.text
						college_url.slice! "Website:"
						college_url = college_url.gsub(/\s+/, "")
						puts college_url
					end

					if inner_content['class'] == "clg-estd clgAtt"
						college_est = inner_content.text
						college_est.slice! "Estd:"
						college_est = college_est.gsub(/\s+/, "")
						puts college_est
					end

					if inner_content['class'] == "clg-type clgAtt" && entry == 1
						college_type = inner_content.text
						college_type.slice! "Type:  "
						puts college_type
						entry = 0
					end

					if inner_content['class'] == "clg-contact clgAtt"
						college_contact_number = inner_content.text
						college_contact_number.slice! "Contact:"
						college_contact_number = college_contact_number.gsub(/\s+/, "")
						puts college_contact_number
						entry = 0
					end

					if  inner_content['class'] == "flag-link flag-default-link"
						entry = 1 
						CSV.open("output.csv", "a") do |csv|
						csv << ["#{college_name}","#{college_location}","#{college_url}", "#{college_contact_number}","#{college_type}","#{college_est}"]
						end
					end
					puts inner_content
					content_id = content_id + 1
			end
		end 
		
		count = count + 1
	        final_buttons = content.css('div')
		if content['class'] == "pager-next"
			#puts content
			next_content = content.css('a').map { |link| link['href'] }
			puts next_content
			next_url = BASE_URL+next_content[0]
			crawler next_url
		end
	end
end

start_url = BASE_URL+EXTRA_URL
crawler start_url
	



