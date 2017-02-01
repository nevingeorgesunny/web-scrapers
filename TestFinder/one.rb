require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

DATA_DIR = "data-hold/content"
Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)
BASE_WIKIPEDIA_URL = "https://en.wikipedia.org"
LIST_URL = "#{BASE_WIKIPEDIA_URL}/wiki/List_of_institutions_of_higher_education_in_Karnataka"
HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}"}
BASE_URL = "https://en.wikipedia.org/wiki/List_of_universities_in_India"
base_page = Nokogiri::HTML(open(BASE_URL))
base_rows = base_page.css('div.mw-content-ltr table.wikitable tr')

base_rows.each do |base_row|

	base_hrefs = base_row.css("td a").map{ |a| 
		a['href'] if a['href'] =~ /^\/wiki\//  && 
			a['href'].include?("institutions")
	}.compact.uniq 
	base_hrefs_titles = base_row.css("td a").map{ |a| 
		a['title'] if a['href'] =~ /^\/wiki\//  && 
			a['href'] !~ /institutions/
	}.compact.uniq 
	LIST_DEPTH_0 = "#{BASE_WIKIPEDIA_URL}#{base_hrefs[0]}"
	state_name = base_hrefs_titles[0]
	page = Nokogiri::HTML(open(LIST_DEPTH_0))
	affiliated_lists = page.css('div.mw-content-ltr table.wikitable tr')
	if affiliated_lists == nil
		puts "\n\n*******ERROR*******"
	end
	rowCount=0;

	rows = page.css('div.mw-content-ltr table.wikitable tr')
	rows.each do |row|

		university_location = nil
		rowCount=rowCount+1
		hrefs = row.css("td a").map{ |a| 
			a['href'] if a['href'] =~ /^\/wiki\//  && (
				a['href'].include?("Academy") or 
				a['href'].include?("Education") or
				a['href'].include?("Institute") or
				a['href'].include?("University") )
		}.compact.uniq
		locations = row.css("td")
		if locations[1] != nil
			university_location = locations[1].text
		end
		if locations[1] == nil
			university_location = "test"
		end
		puts "\n\nLOCATION = #{university_location}"
		count=0
		page_title = row.css("td a").map{ |a| 
			a['title'] if a['href'] =~ /^\/wiki\//  && (
				a['href'].include?("Academy") or 
				a['href'].include?("Education") or
				a['href'].include?("Institute") or
				a['href'].include?("University") )
		}.compact.uniq
		puts "\n\nTITLE = #{page_title}"
	
		hrefs.each do |href|

			count=count+1
			LIST_DEPTH_1 = "#{BASE_WIKIPEDIA_URL}#{hrefs[0]}"
			page_depth_1 = Nokogiri::HTML(open(LIST_DEPTH_1))
			row_depth_1 = page_depth_1.css('div.mw-content-ltr table.infobox tr')
			count_row_depth_1=0

			row_depth_1[0..-1].each do |row_depth_1|
			
				hrefs_depth_1 = row_depth_1.css("td a").map{ |a| 
					 a['href'] if  (a['class']||'').include?("external") &&
						       (a['href']||'') !~ /tools/
				}.compact.uniq
				if hrefs_depth_1[0] != nil
					csv_output = "#{page_title[0]},#{hrefs_depth_1[0]}"
					CSV.parse(csv_output)
					CSV.open("output.csv", "a") do |csv|
						csv << ["#{page_title[0]}","#{state_name}","#{university_location}", "#{hrefs_depth_1[0]}"]
					end
					#File.open("output.csv", "a") {|f| f.puts csv_output}
					puts "\n\n    DATA = #{csv_output }    \n\n "
				end
			end
			puts "\n----#{hrefs[0]}------Col Coubt : #{count} --------------Row Count : #{rowCount} \n"

		end 
	end 
end
