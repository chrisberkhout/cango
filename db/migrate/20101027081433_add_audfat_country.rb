class AddAudfatCountry < ActiveRecord::Migration
  def self.up
    create_table :audfat_countries do |t|
      t.string   :name,            :null => false
      t.string   :url,             :null => false
      t.date     :last_issued_on
      t.integer  :last_scrape_id,  :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :audfat_countries
  end
end
