class AUDFATScrape < Scrape
  has_many :countries, :class_name => 'AUDFATCountry', :foreign_key => :last_scrape_id
end
