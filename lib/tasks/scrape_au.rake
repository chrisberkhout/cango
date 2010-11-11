require 'nokogiri'
require 'open-uri'

namespace :scrape do
  desc 'Load or update the Australian DFAT data'
  task :au => :environment do
    
    scrape = AUScrape.create!(:started_at => Time.now, :successful => false)
    
    AUScrape.transaction do
      index_url = 'http://www.smartraveller.gov.au/zw-cgi/view/Advice/'
    
      Nokogiri::HTML(open(index_url)).css('div#alphaTOC a.topicTitle').each do |country_node|
      
        country_name = country_node.text.strip
        next if country_name.is_in? ['General Advice to Australian Travellers', 'Travelling by Sea']
        country_url = index_url + country_node[:href]
        issue_date = country_node.parent.parent.css('span.issueDate').text.strip.map { |s| s.blank? ? nil : Date.strptime(s, '%d/%m/%Y') }.first
        country = AUCountry.where(:name => country_name).first || AUCountry.new(:name => country_name)

        printf "#{country_name.upcase}: "
        if country.last_issued_on != issue_date then
          puts "advice from #{country_url}, issued on #{issue_date}:"
          Nokogiri::HTML(open(country_url)).css('table#alertContinuii th.alertLocation').each do |area_node|
            area = area_node.text.strip
            level = AULevel[area_node.parent.parent.css('td.currentAlertLevel').first.text.strip]
            puts "     #{AULevel[level]} in #{area}."
            country.advices << AUAdvice.new(
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

    
    # missing_countries = []
    # new_countries = []
    # missing_area_advices = []
    # new_area_advices = []
    puts "--------------------------------------------------------------------------------"
    puts " Structural changes in #{scrape.type} \##{scrape.id}, started at #{scrape.started_at}"
    puts "--------------------------------------------------------------------------------"
    AUCountry.all.each do |c| 
      if c.not_in? scrape.countries 
        # missing_countries << c 
        puts "The country #{c.name.upcase} was not found in this scrape!"
      elsif c.created_at > scrape.started_at
        # new_countries << c 
        puts "The country #{c.name.upcase} first appeared in this scrape!"
      else
        previous_issue = c.advices.group(:issued_on).order('issued_on DESC').map{|o| o.issued_on }[1]
        c.advices.where(:issued_on => previous_issue).each do |previous_advice| 
          if c.last_advices.where(:area => previous_advice.area).blank? then
            # missing_area_advices << previous_advice 
            puts "The #{previous_advice.country.name.upcase} area #{previous_advice.area.upcase} was not found in this scrape!"
          end
        end
        c.last_advices.where('created_at > ?', scrape.started_at).each do |new_advice|
          if c.advices.where(:area => new_advice.area, :issued_on => previous_issue).blank? then
            # new_area_advices << new_advice 
            puts "The #{new_advice.country.name.upcase} area #{new_advice.area.upcase} first appeared in this scrape!"
          end
        end
      end
    end

    
  end
end
