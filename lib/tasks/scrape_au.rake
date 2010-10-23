require 'nokogiri'
require 'open-uri'

namespace :scrape do
  desc 'Update the Australian DFAT data'
  task :au => :environment do
    
    scrape = AUDFATScrape.create!(:started_at => Time.now, :successful => false)
    
    index_url = 'http://www.smartraveller.gov.au/zw-cgi/view/Advice/'
    
    Nokogiri::HTML(open(index_url)).css('div#alphaTOC a.topicTitle').each do |title_node|
      
      country_url = index_url + title_node[:href]
      country_name = title_node.text.strip
      issue_date = title_node.parent.parent.css('span.issueDate').text.strip.map { |s| s.blank? ? nil : Date.strptime(s, '%d/%m/%Y') }.first
      country = AUDFATCountry.where(:name => country_name).first || AUDFATCountry.new(:name => country_name)

      printf "#{country_name.upcase}: "
      if country.last_issued_on != issue_date then
        puts "advice from #{country_url}, issued on #{issue_date}:"
        Nokogiri::HTML(open(country_url)).css('table#alertContinuii th.alertLocation').each do |area_node|
          area = area_node.text.strip
          level = AUDFATLevel[area_node.parent.parent.css('td.currentAlertLevel').first.text.strip]
          puts "     #{AUDFATLevel[level]} in #{area}."
          country.advices << AUDFATAdvice.new(
            :area => area,
            :overall => area[/ overall$/].present?,
            :issued_on => issue_date,
            :level => level
          )
        end
      else
        puts "already up to date."
      end
      
      country.update_attributes!({
        :url => country_url,
        :last_issued_on => issue_date,
        :last_scrape => scrape
      })

    end
    
    scrape.update_attributes!(:ended_at => Time.now, :successful => true)
    
  end
end
