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
    profile_info = {}
    doc.css(".social-icon-container a").each do |links|
      link = links.attribute("href").text
      if link.include?("twitter")
        profile_info[:twitter] = link
      elsif link.include?("linkedin")
       profile_info[:linkedin] = link
      elsif link.include?("github")
        profile_info[:github] = link
      else profile_info[:blog] = link
      end
    end
    
    profile_info[:profile_quote] = doc.css(".profile-quote").text
    profile_info[:bio] = doc.css("p").text
    profile_info
    
  end

end
