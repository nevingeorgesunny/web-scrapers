require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'open-uri'
require 'csv'




LOGIN_URL = "https://www.linkedin.com/uas/login?goback=&trk=hb_signin"



def crawler(url,agent,page_index,parent_user_search_keyword,parent_user_limit)
    
   base_page = url 

    pp base_page.links
    puts "\n\n-----------------------------------------------"
    raw_results = base_page.search('div')
    raw_results.each do |result|

        result_id = result['id']
        result_class = result['class']
        if result_id == "srp_main_"		
            puts result_id	
            puts result_class	
            inner_result =  result.at('fmt_name')
            string = result.inner_html
            copy = string.split("")
            number = string.length
            puts number
            number = number -1 
            ch = string[number]
            puts ch
            loop_count_forward = 0
            copy.each do |str|
                if str == '{'
                    break
                end
                loop_count_forward = loop_count_forward + 1
                print str
                string.slice!(0)
            end
            puts "\n\n"		
            loop_count_reverse = 0
            copy.reverse.each do |str|
                if str == '}'
                    break
                end
                loop_count_reverse = loop_count_reverse + 1
                print str
            end
            puts loop_count_reverse
            loop_count_reverse.times do string.chop! end

            File.write('results.txt', string)
            parsed = JSON.parse(string)
            parsed = parsed["person"]
            pp parsed
            copy = string.split("")
            target_parent_link_found=1

            copy.each_with_index { |s,i|


                
                profile_name = String.new
                
                
                element = copy[i]
                if element == "f"
                next_element = copy[i+1]
                if next_element  == "m"
                next_element_depth_1 = copy[i+2]
                if next_element_depth_1 == "t"
                next_element_depth_2 = copy[i+3]
                if next_element_depth_2 == "_"	
                next_element_depth_3 = copy[i+4]
                if next_element_depth_3 == "n"	
                next_element_depth_4 = copy[i+5]
                if next_element_depth_4 == "a"	
                loop_counter = i+5
                full_name_toggle = 0
                hit_count = 0
                   
                    while 1 == 1 do
                        loop_counter = loop_counter + 1
                        loop_element = copy[loop_counter]
                            if loop_element == "\""
                                hit_count = hit_count + 1	
                                if full_name_toggle == 1
                                    full_name_toggle = 0
                                    puts "\n\n"
                                    break
                                end
                                if full_name_toggle == 0 &&	
                                    hit_count == 2
                                    full_name_toggle = 1
                                end
                            end		
                                if full_name_toggle ==1 &&
                                    loop_element != "\""
                                    profile_name.concat(loop_element)
                                end
                    end
                    
                    print profile_name
                    
                    open('output.csv', 'a') do |f|
                      profile_name = "\n"'"'+profile_name+'"'     
                      f << profile_name
                      f << ","
                    end
                   
                    target_parent_link_found = 0
                end	
                end	
                end	
                end			
                end
                end

                
                
               
                
                
                if target_parent_link_found == 0
                    
                if element == "l"
                next_element = copy[i+1]
                if next_element  == "i"
                next_element_depth_1 = copy[i+2]
                if next_element_depth_1 == "n"
                next_element_depth_2 = copy[i+3]
                if next_element_depth_2 == "k"	
                next_element_depth_3 = copy[i+4]
                if next_element_depth_3 == "_"	
                next_element_depth_4 = copy[i+5]
                if next_element_depth_4 == "n"
                next_element_depth_5 = copy[i+6]
                if next_element_depth_5 == "p"
                next_element_depth_6 = copy[i+7]
                if next_element_depth_6 == "r"
                next_element_depth_7 = copy[i+8]    
                if next_element_depth_7 == "o"
                     
                next_element_depth_8 = copy[i+9]    
                if next_element_depth_8 == "f"
                next_element_depth_9 = copy[i+10]    
                if next_element_depth_9 == "i"
                next_element_depth_10 = copy[i+11]    
                if next_element_depth_10 == "l"
                next_element_depth_11 = copy[i+12]
                if next_element_depth_11 == "e"
                next_element_depth_12 = copy[i+13]    
                if next_element_depth_12 == "_"
                next_element_depth_13 = copy[i+14]    
                if next_element_depth_13 == "v"
                next_element_depth_14 = copy[i+15]    
                if next_element_depth_14 == "i"
                next_element_depth_15 = copy[i+16]    
                if next_element_depth_15 == "e"
                next_element_depth_16 = copy[i+17]    
                if next_element_depth_16 == "w"
                next_element_depth_17 = copy[i+18]    
                loop_counter = i+5
                full_name_toggle = 0
                hit_count = 0
                    profile_url = String.new
                    
                    

                    while 1 == 1 do
                        loop_counter = loop_counter + 1
                        loop_element = copy[loop_counter]
                            if loop_element == "\""
                                hit_count = hit_count + 1	
                                if full_name_toggle == 1
                                    full_name_toggle = 0
                                    puts "\n\n"
                                    break
                                end
                                if full_name_toggle == 0 &&	
                                    hit_count == 2
                                    full_name_toggle = 1
                                end
                            end		
                                if full_name_toggle ==1 &&
                                    loop_element != "\""
                                    profile_url.concat(loop_element)
                                end
                    end

                  profile_url.gsub! '\u002d', '-' 
                  print profile_url 
                    
                    
                     open('output.csv', 'a') do |f|
                      profile_name = '"'+profile_name+'"'     
                      f << profile_url
                      f << ","
                    end


                   traget_profile_page = agent.get(profile_url)





                    String  traget_profile_page_content = traget_profile_page.content

                    traget_profile_page_content_copy = traget_profile_page_content.split("")
                     profile_email= String.new
                    
                    traget_profile_page_content_copy.each_with_index{ |s,i|

                        element = traget_profile_page_content[i]
                        if element == 'e'
                        element_depth_1 = traget_profile_page_content[i+1] 
                        if element_depth_1 == 'm'
                        element_depth_2 = traget_profile_page_content[i+2] 
                        if element_depth_2 == 'a'
                        element_depth_3 = traget_profile_page_content[i+3] 
                        if element_depth_3 == 'i'
                        element_depth_4 = traget_profile_page_content[i+4]      
                        if element_depth_4 == 'l'
                        element_depth_5 = traget_profile_page_content[i+5] 
                        if element_depth_5 == '-'
                        element_depth_6 = traget_profile_page_content[i+6] 
                        if element_depth_6 == 'v'
                        element_depth_7 = traget_profile_page_content[i+7] 
                        if element_depth_7 == 'i'
                        element_depth_8 = traget_profile_page_content[i+8] 
                        if element_depth_8 == 'e'
                        element_depth_9 = traget_profile_page_content[i+9] 
                        if element_depth_9 == 'w'
                        element_depth_10 = traget_profile_page_content[i+10]  
                            print "\n\n"
                            index = 0
                            primary_Hit = 0
                            secondary_hit = 0
                            first_quote_hit = 0;
                            second_quote_hit = 0;
                           
                            while 1 == 1 do
                                loop_element =  traget_profile_page_content[10+index+i+1] 
                                if loop_element == '"'
                                     if first_quote_hit == 1 && second_quote_hit == 0
                                        second_quote_hit = 1
                                    end    
                                    if first_quote_hit == 0 && second_quote_hit == 0
                                        first_quote_hit = 1
                                    end    
                                end
                                if  first_quote_hit == 1 && second_quote_hit == 1 && loop_element == ">"   
                                    primary_Hit = 1
                                end
                                if  first_quote_hit == 1 && second_quote_hit == 1 && loop_element == "<"   
                                    secondary_hit = 1
                                end
                                if secondary_hit == 1
                                    break
                                end
                                if primary_Hit == 1 && loop_element != ">" && loop_element != "<"
                                     profile_email.concat(loop_element)
                                end
                                index = index + 1
                            end
                            
                             
                            print profile_email
                            
                            
                               open('output.csv', 'a') do |f|
                                  profile_name = '"'+profile_name+'"'     
                                  f << profile_email
                                end
                         
                            
                           
                        end
                        end
                        end
                        end
                        end
                        end
                        end
                        end
                        end
                        end
                        
                       
                        }
                    
                     
                    
                    
                  puts "\n\n"
                  target_parent_link_found = 1
                    
                    
                end	
                end	
                end	
                end			
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
                end
            }
        end
    end
    page_index = page_index + 1
    page_index_url = "https://www.linkedin.com/vsearch/f?keywords="+parent_user_search_keyword+"&pt=people&page_num="
    page_index_url = page_index_url + page_index.to_s
    page_index_url_agent = agent.get(page_index_url)
    if page_index <= parent_user_limit.to_i
        crawler page_index_url_agent,agent,page_index,parent_user_search_keyword,parent_user_limit
    end
end






print "Enter Email: "
parent_user_email = gets


print "\nEnter Search KeyWord :  "
parent_user_search_keyword = gets


print "\nEnter Number of pages  :"
parent_user_limit = gets

`stty -echo`
print "\nEnter Password: "
parent_user_password = gets.chomp
`stty echo`





base_page = Nokogiri::HTML(open(LOGIN_URL))
loop_element =nil
login_content = base_page.css('form#login') 
puts login_content
agent = Mechanize.new
login_page = agent.get(LOGIN_URL)
pp login_page
linkedin_login_form = login_page.form('login')
puts linkedin_login_form.fields
linkedin_login_form.session_key = parent_user_email
linkedin_login_form.session_password = parent_user_password
puts "\n\n SUCCESS"
base_page = agent.submit(linkedin_login_form, linkedin_login_form.buttons.first)
linkedin_search_form = base_page.form
puts linkedin_search_form
page_index_url = "https://www.linkedin.com/vsearch/f?keywords="+parent_user_search_keyword+"&pt=people&page_num=1"
base_page = agent.get(page_index_url)
   
pp base_page
crawler base_page,agent,1,parent_user_search_keyword,parent_user_limit














