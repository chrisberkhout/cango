class AddIsoBorders < ActiveRecord::Migration
  def self.up
    change_table :iso_countries do |t|
      t.text :borders_kml
    end
  end

  def self.down
    change_table :iso_countries do |t|
      t.remove :borders_kml
    end
  end
end
