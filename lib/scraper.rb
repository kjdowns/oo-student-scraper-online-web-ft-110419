require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_hash_array = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |card|
      student_hash = {
        :name => card.css(".student-name").text, 
        :location => card.css(".student-location").text,
        :profile_url => card.css("a").attribute("href").value}
      student_hash_array << student_hash
    end
    student_hash_array
  end

  def self.scrape_profile_page(profile_url)
    student_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    last_name = doc.css(".vitals-text-container .profile-name").text.split(" ")[1].downcase
    student_hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text.strip
    student_hash[:bio] = doc.css(".description-holder p").text
    
    #iterate over social-icon-container and match each value with social key if it exists
    doc.css(".social-icon-container a").each do |social_icon|
      if social_icon.attribute("href").value.include?("twitter")
        student_hash[:twitter] = social_icon.attribute("href").value
      elsif social_icon.attribute("href").value.include?("linkedin")
        student_hash[:linkedin] = social_icon.attribute("href").value
      elsif social_icon.attribute("href").value.include?("github")
        student_hash[:github] = social_icon.attribute("href").value
      elsif social_icon.attribute("href").value.include?(last_name)
        student_hash[:blog] = social_icon.attribute("href").value
      end
    end
    student_hash
  end

end

# student name => doc.css(".student-card")[0].css(".student-name").text
# student location => doc.css(".student-card")[0].css(".student-location").text
# student profile_url => doc.css(".student-card")[0].css("a").attribute("href").value

# twitter => doc.css(".social-icon-container a")[index].attribute("href").value
# linkedin => doc.css(".social-icon-container a")[index].attribute("href").value
# github => doc.css(".social-icon-container a")[index].attribute("href").value
# blog => doc.css(".social-icon-container a")[index].attribute("href").value
# profile_quote =>  doc.css(".vitals-text-container .profile-quote").text.strip
# bio => doc.css(".description-holder p").text