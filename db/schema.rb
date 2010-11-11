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

ActiveRecord::Schema.define(:version => 20101110100623) do

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

  create_table "iso_countries", :force => true do |t|
    t.string   "official_short_name", :null => false
    t.string   "name",                :null => false
    t.string   "code",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrapes", :force => true do |t|
    t.string   "type",                          :null => false
    t.datetime "started_at",                    :null => false
    t.datetime "ended_at"
    t.boolean  "successful", :default => false
  end

end
