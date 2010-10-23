class AddScrapeModel < ActiveRecord::Migration
  def self.up
    create_table :scrapes do |t|
      t.string   :type, :null => false
      t.datetime :started_at, :null => false
      t.datetime :ended_at
      t.boolean  :successful, :default => false
    end
  end

  def self.down
    drop_table :scrapes
  end
end
