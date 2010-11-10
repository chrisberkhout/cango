class AddIso3166Model < ActiveRecord::Migration
  def self.up
    create_table :iso3166_countries do |t|
      t.string   :official_short_name, :null => false
      t.string   :name,                :null => false
      t.string   :code,                :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :iso3166_countries
  end
end
