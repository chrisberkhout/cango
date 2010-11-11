class AUScrape < Scrape
  has_many :countries, :class_name => 'AUCountry', :foreign_key => :last_scrape_id
end
