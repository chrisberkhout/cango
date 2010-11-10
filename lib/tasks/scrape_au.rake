require 'nokogiri'
require 'open-uri'

namespace :scrape do
  desc 'Update the Australian DFAT data'
  task :au => :environment do
    
    scrape = AUDFATScrape.create!(:started_at => Time.now, :successful => false)
    
    AUDFATScrape.transaction do
      index_url = 'http://www.smartraveller.gov.au/zw-cgi/view/Advice/'
    
      Nokogiri::HTML(open(index_url)).css('div#alphaTOC a.topicTitle')[0..10].each do |country_node|
      
        country_name = country_node.text.strip
        next if country_name.is_in? ['General Advice to Australian Travellers', 'Travelling by Sea']
        country_url = index_url + country_node[:href]
        issue_date = country_node.parent.parent.css('span.issueDate').text.strip.map { |s| s.blank? ? nil : Date.strptime(s, '%d/%m/%Y') }.first
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
          :last_scrape => scrape,
        })

      end
    
      scrape.update_attributes!(:ended_at => Time.now, :successful => true)
    end
    
  end
end
