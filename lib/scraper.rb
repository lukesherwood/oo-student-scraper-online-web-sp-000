require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    #returns an array of hashes in which each hash represents one student
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_info = {:name => name,
                      :location => location,
                      :profile_url => profile_url}
      students << student_info
      end
    students
   end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    link_array = []
    
    doc.css(".social-icon-container a").each do |links|
      link = links.attribute("href").text
      link_array << link
      end
    twitter = link_array[0]
    linkedin = link_array[1]
    github = link_array[2]
    blog = link_array[3] 
    
    profile_quote = doc.css(".profile-quote").text
    bio = doc.css("p").text
    
    profile_info = {twitter: twitter, linkedin: linkedin, github: github, blog: blog, profile_quote: profile_quote, bio: bio}
    
  end

end
