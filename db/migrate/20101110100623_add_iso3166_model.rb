class AddIsoModel < ActiveRecord::Migration
  def self.up
    create_table :iso_countries do |t|
      t.string   :official_short_name, :null => false
      t.string   :name,                :null => false
      t.string   :code,                :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :iso_countries
  end
end
