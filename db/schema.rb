# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101118120652) do

  create_table "au_advices", :force => true do |t|
    t.integer  "country_id",                    :null => false
    t.string   "area",                          :null => false
    t.boolean  "overall",    :default => false, :null => false
    t.integer  "level",                         :null => false
    t.date     "issued_on",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "au_countries", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "url",            :null => false
    t.date     "last_issued_on"
    t.integer  "last_scrape_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "au_countries_iso_countries", :id => false, :force => true do |t|
    t.integer "au_country_id",  :null => false
    t.integer "iso_country_id", :null => false
  end

  add_index "au_countries_iso_countries", ["au_country_id", "iso_country_id"], :name => "au_iso_unique", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments_iso_countries", :id => false, :force => true do |t|
    t.integer "comment_id",     :null => false
    t.integer "iso_country_id", :null => false
  end

  add_index "comments_iso_countries", ["comment_id", "iso_country_id"], :name => "comment_iso_unique", :unique => true

  create_table "iso_countries", :force => true do |t|
    t.string   "official_short_name", :null => false
    t.string   "name",                :null => false
    t.string   "code",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "borders_kml"
  end

  create_table "scrapes", :force => true do |t|
    t.string   "type",                          :null => false
    t.datetime "started_at",                    :null => false
    t.datetime "ended_at"
    t.boolean  "successful", :default => false
  end

end
