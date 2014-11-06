# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130117223125) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_merits_info_id"
    t.string   "name"
    t.string   "action_type"
    t.string   "status",              :default => "unstarted"
    t.string   "message"
    t.integer  "score"
    t.integer  "child_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "achieves", :force => true do |t|
    t.integer  "user_merits_info_id"
    t.string   "name"
    t.string   "action_type"
    t.string   "status",              :default => "unstarted"
    t.string   "message"
    t.integer  "score"
    t.integer  "child_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "addresses", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "name"
    t.string   "street"
    t.string   "complement"
    t.string   "district"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "region"
    t.string   "gmaps"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "appointments", :force => true do |t|
    t.datetime "data"
    t.integer  "dress_id"
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "telephone"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bookmarks", :force => true do |t|
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.integer  "user_id"
    t.text     "comments"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "dress_photos", :force => true do |t|
    t.integer  "dress_id"
    t.string   "image"
    t.text     "name"
    t.boolean  "cover",      :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "dresses", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "name"
    t.string   "brand"
    t.string   "description"
    t.boolean  "featured"
    t.integer  "share",                      :default => 0
    t.string   "sleeve"
    t.string   "neckline"
    t.string   "silhouette"
    t.string   "fabric"
    t.string   "length"
    t.integer  "price",       :limit => 255
    t.float    "weight"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "train"
    t.string   "finish"
    t.string   "color"
    t.text     "details"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dress_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorites", ["dress_id", "user_id"], :name => "index_favorites_on_dress_id_and_user_id", :unique => true

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.string   "img_url"
    t.string   "url"
    t.datetime "published_at"
    t.string   "guid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "categories"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "hints", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "merits", :force => true do |t|
    t.string   "merits_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "merits_actions", :force => true do |t|
    t.integer  "user_merits_info_id"
    t.integer  "score"
    t.string   "action"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "notified",            :default => false
    t.string   "description"
  end

  create_table "merits_hints", :force => true do |t|
    t.integer  "merit_id"
    t.integer  "hint_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "image"
    t.string   "name"
    t.boolean  "cover",      :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "proposals", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "quotation_id"
    t.string   "document"
    t.text     "description"
    t.date     "date"
    t.string   "validity"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "quotations", :force => true do |t|
    t.integer  "user_id"
    t.string   "comments"
    t.integer  "vendor_id"
    t.string   "telephone"
    t.integer  "number_guests"
    t.date     "wedding_date"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "status",        :default => "Aguardando"
    t.date     "sent_at"
    t.string   "email",         :default => "",           :null => false
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.text     "content"
    t.boolean  "recommendation"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "title"
    t.date     "date"
    t.boolean  "anonymous"
    t.string   "anonymous_picture"
    t.string   "reviewer_type"
    t.date     "review_of_the_day"
    t.integer  "number_of_iframe_clicks", :default => 0
    t.integer  "number_of_home_clicks",   :default => 0
  end

  create_table "searches", :force => true do |t|
    t.string   "service_type"
    t.string   "name"
    t.string   "address"
    t.string   "search_source"
    t.integer  "filter",          :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "sort_by"
    t.integer  "distance"
    t.string   "price"
    t.string   "ip_address"
    t.string   "user_id"
    t.integer  "filter_details1", :default => 0, :null => false
    t.string   "filter_details2"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "track_details", :force => true do |t|
    t.integer  "track_id"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "track_dresses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dress_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.string   "ip"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_merits_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "merit_id"
    t.integer  "points"
    t.boolean  "closed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "genre"
    t.string   "profile_picture"
    t.date     "wedding_date"
    t.date     "birth_date"
    t.string   "role"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "location"
    t.string   "relationship_status"
    t.string   "significant_other"
    t.string   "significant_other_id"
    t.integer  "number_guests"
    t.string   "cpf"
    t.string   "telephone"
    t.string   "referral_token"
    t.integer  "referrer_id"
    t.boolean  "mailing",                :default => true
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["referral_token"], :name => "index_users_on_referral_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "slug"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.decimal  "rating_average_quality",         :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_professionalism", :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_price",           :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_flexibility",     :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average",                 :precision => 6, :scale => 2, :default => 0.0
    t.integer  "number_reviews"
    t.integer  "featured",                                                     :default => 0
    t.string   "price"
    t.text     "price_details"
    t.integer  "venue_details",                                                :default => 0,    :null => false
    t.integer  "catering_details",                                             :default => 0,    :null => false
    t.integer  "photography_details",                                          :default => 0,    :null => false
    t.integer  "invitation_details",                                           :default => 0,    :null => false
    t.integer  "travel_details",                                               :default => 0,    :null => false
    t.integer  "band_details",                                                 :default => 0,    :null => false
    t.integer  "gift_details",                                                 :default => 0,    :null => false
    t.integer  "beauty_details",                                               :default => 0,    :null => false
    t.integer  "jewelry_details",                                              :default => 0,    :null => false
    t.integer  "decoration_details",                                           :default => 0,    :null => false
    t.integer  "cake_details",                                                 :default => 0,    :null => false
    t.integer  "planner_details",                                              :default => 0,    :null => false
    t.integer  "other_details",                                                :default => 0,    :null => false
    t.string   "type"
    t.string   "details_field1"
    t.text     "details_field2"
    t.integer  "details_field3"
    t.boolean  "active",                                                       :default => true, :null => false
    t.integer  "garment_details"
    t.boolean  "discount"
    t.string   "discount_title"
    t.text     "discount_description"
    t.string   "off_listing_reason"
    t.boolean  "mailing",                                                      :default => true
    t.string   "email2"
  end

  add_index "vendors", ["slug"], :name => "index_vendors_on_slug"

end
