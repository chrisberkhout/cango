class AddAudfatAdvice < ActiveRecord::Migration
  def self.up
    create_table :audfat_advices do |t|
      t.integer  :country_id, :null => false
      t.string   :area,       :null => false
      t.boolean  :overall,    :null => false, :default => false
      t.integer  :level,      :null => false
      t.date     :issued_on,  :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :audfat_advices
  end
end
