class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.text :body

      t.timestamps
    end
    create_table :comments_iso_countries, :id => false do |t|
      t.integer :comment_id,  :null => false
      t.integer :iso_country_id, :null => false
    end
    add_index :comments_iso_countries, [:comment_id, :iso_country_id], :unique => true, :name => :comment_iso_unique
  end

  def self.down
    remove_index :comments_iso_countries, [:comment_id, :iso_country_id]
    drop_table :comments_iso_countries
    drop_table :comments
  end
end
