class AddJoinBetweenAuAndIsoCountries < ActiveRecord::Migration
  def self.up
    create_table :au_countries_iso_countries, :id => false do |t|
      t.integer :au_country_id,  :null => false
      t.integer :iso_country_id, :null => false
    end
    add_index :au_countries_iso_countries, [:au_country_id, :iso_country_id], :unique => true, :name => :au_iso_unique
  end

  def self.down
    remove_index :au_countries_iso_countries, [:au_country_id, :iso_country_id]
    drop_table :au_countries_iso_countries
  end
end
