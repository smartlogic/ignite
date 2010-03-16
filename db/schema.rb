# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100316173555) do

  create_table "admins", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "ignite_id"
  end

  add_index "admins", ["login"], :name => "index_admins_on_login", :unique => true
  add_index "admins", ["ignite_id"], :name => "index_admins_on_ignite_id"

  create_table "articles", :force => true do |t|
    t.string   "name"
    t.boolean  "is_news",            :default => false
    t.text     "html_text"
    t.boolean  "is_sticky",          :default => false
    t.boolean  "comments_allowed",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ignite_id"
    t.boolean  "show_in_navigation", :default => false
  end

  add_index "articles", ["ignite_id"], :name => "index_articles_on_ignite_id"

  create_table "comments", :force => true do |t|
    t.string   "author"
    t.string   "email"
    t.string   "url"
    t.text     "content"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",                                     :null => false
    t.datetime "date",                                     :null => false
    t.string   "location_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.boolean  "is_featured",           :default => false
    t.string   "rsvp_url"
    t.string   "map_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_complete",           :default => false, :null => false
    t.string   "summary_image"
    t.string   "sponsors_url"
    t.string   "videos_url"
    t.string   "images_url"
    t.string   "summary_image_caption"
    t.integer  "ignite_id"
    t.integer  "position"
    t.boolean  "accepting_proposals",   :default => false
  end

  add_index "events", ["ignite_id"], :name => "index_events_on_ignite_id"

  create_table "events_organizers", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "organizer_id"
  end

  add_index "events_organizers", ["event_id", "organizer_id"], :name => "index_events_organizers_on_event_id_and_organizer_id", :unique => true
  add_index "events_organizers", ["event_id"], :name => "index_events_organizers_on_event_id"
  add_index "events_organizers", ["organizer_id"], :name => "index_events_organizers_on_organizer_id"

  create_table "events_sponsors", :id => false, :force => true do |t|
    t.integer "event_id",   :null => false
    t.integer "sponsor_id", :null => false
  end

  add_index "events_sponsors", ["event_id", "sponsor_id"], :name => "index_events_sponsors_on_event_id_and_sponsor_id"
  add_index "events_sponsors", ["event_id"], :name => "index_events_sponsors_on_event_id"
  add_index "events_sponsors", ["sponsor_id"], :name => "sponsor_id"

  create_table "ignites", :force => true do |t|
    t.string   "city",                    :null => false
    t.string   "logo_image"
    t.string   "banner_background_image"
    t.string   "banner_bottom_image"
    t.string   "twitter_username"
    t.string   "twitter_feed_url"
    t.string   "domain",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizers", :force => true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "email"
    t.string   "personal_url"
    t.string   "blog_url"
    t.string   "company_url"
    t.string   "twitter_url"
    t.string   "linkedin_url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ignite_id"
  end

  add_index "organizers", ["ignite_id"], :name => "index_organizers_on_ignite_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "speakers", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.text     "bio"
    t.string   "email"
    t.integer  "event_id"
    t.string   "blog_url"
    t.string   "twitter_url"
    t.string   "linkedin_url"
    t.string   "personal_url"
    t.string   "company_url"
    t.string   "video_url"
    t.integer  "position"
    t.string   "image"
    t.string   "mouseover_image"
    t.string   "aasm_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "widget_image"
    t.string   "video_embed_url"
  end

  add_index "speakers", ["event_id"], :name => "index_speakers_on_event_id"

  create_table "sponsors", :force => true do |t|
    t.string "name"
    t.string "link"
    t.string "image"
    t.string "aasm_state"
  end

  add_foreign_key "admins", ["ignite_id"], "ignites", ["id"], :name => "admins_ibfk_1"

  add_foreign_key "articles", ["ignite_id"], "ignites", ["id"], :name => "articles_ibfk_1"

  add_foreign_key "events", ["ignite_id"], "ignites", ["id"], :name => "events_ibfk_2"

  add_foreign_key "events_organizers", ["organizer_id"], "organizers", ["id"], :name => "events_organizers_ibfk_2"
  add_foreign_key "events_organizers", ["event_id"], "events", ["id"], :name => "events_organizers_ibfk_1"

  add_foreign_key "events_sponsors", ["event_id"], "events", ["id"], :name => "events_sponsors_ibfk_1"
  add_foreign_key "events_sponsors", ["sponsor_id"], "sponsors", ["id"], :name => "events_sponsors_ibfk_2"

  add_foreign_key "organizers", ["ignite_id"], "ignites", ["id"], :name => "organizers_ibfk_2"

  add_foreign_key "speakers", ["event_id"], "events", ["id"], :name => "speakers_ibfk_1"

end
