require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'json'


LOGIN_USER_NAME = "induslynk3"
LOGIN_USER_PASSWRD = "navall1234"
LOGIN_URL = "https://login.recruit.naukri.com/Login/logout"

base_page = Nokogiri::HTML(open(LOGIN_URL))

contents = base_page.css('input') 

#puts contents

agent = Mechanize.new

page = agent.get(LOGIN_URL)

naukri_login_form = page.form('frmLogin')

puts naukri_login_form





