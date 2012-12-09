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

ActiveRecord::Schema.define(:version => 20110918024958) do

  create_table "access_codes", :force => true do |t|
    t.string   "code"
    t.string   "email_expression"
    t.integer  "role_id"
    t.integer  "uses",             :default => 0
    t.integer  "max_uses"
    t.boolean  "is_active",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "critics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "review_updated_at"
    t.float    "average_score"
    t.float    "median_score"
  end

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.boolean  "is_active",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "panels", :force => true do |t|
    t.string   "title"
    t.integer  "order_seq",                :default => 0
    t.text     "items"
    t.string   "item_label_method"
    t.string   "item_detail_label_method"
    t.string   "item_url_method"
    t.string   "item_accessory_method"
    t.string   "image_url_method"
    t.string   "more_text"
    t.string   "more_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "image_file_name"
    t.string   "unattached_image_url"
    t.text     "image_link"
  end

  create_table "participants", :force => true do |t|
    t.string   "name"
    t.boolean  "is_person",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plays", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_title"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.boolean  "is_published",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.boolean  "is_published_at_override", :default => false
    t.datetime "published_at_override"
    t.integer  "cutoff_length",            :default => 300
  end

  create_table "productions", :force => true do |t|
    t.float    "average_score"
    t.float    "median_score"
    t.string   "ticket_url"
    t.string   "photo_credit"
    t.text     "synopsis"
    t.text     "editorial_summary"
    t.date     "opening_date"
    t.date     "closing_date"
    t.integer  "running_time"
    t.string   "running_time_text"
    t.integer  "theatre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "play_id"
    t.boolean  "is_on_broadway",                :default => false
    t.boolean  "is_musical",                    :default => false
    t.boolean  "is_for_adults",                 :default => false
    t.boolean  "is_for_families",               :default => false
    t.boolean  "is_for_kids",                   :default => false
    t.datetime "review_updated_at"
    t.string   "is_playing_override"
    t.string   "photo_file_name"
    t.string   "photo_content_tyle"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "byline"
    t.boolean  "is_published_site",             :default => false
    t.boolean  "is_published_feed",             :default => false
    t.integer  "posted_by_id"
    t.datetime "site_published_at"
    t.datetime "feed_published_at"
    t.boolean  "is_site_published_at_override", :default => false
    t.boolean  "is_feed_published_at_override", :default => false
    t.datetime "site_published_at_override"
    t.datetime "feed_published_at_override"
    t.string   "play_title"
    t.string   "play_sort_title"
    t.float    "average_user_score"
    t.float    "median_user_score"
    t.datetime "user_review_updated_at"
    t.string   "ad_file_name"
    t.string   "ad_content_tyle"
    t.integer  "ad_file_size"
    t.datetime "ad_updated_at"
    t.string   "ad_url"
    t.date     "preview_date"
    t.string   "teaser"
    t.float    "min_ticket_price"
    t.float    "max_ticket_price"
    t.boolean  "has_stars",                     :default => false
    t.string   "broadway_com_id"
    t.boolean  "is_show_custom_ad",             :default => false
    t.boolean  "is_replace_photo",              :default => true
  end

  create_table "publications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "review_updated_at"
    t.float    "average_score"
    t.float    "median_score"
  end

  create_table "quotes", :force => true do |t|
    t.text     "text"
    t.boolean  "is_active",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_connector"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "play_id"
    t.integer  "relationship_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.integer  "production_id"
    t.string   "custom_connector"
  end

  create_table "reports", :force => true do |t|
    t.string   "text"
    t.boolean  "is_spam",        :default => false
    t.integer  "user_review_id"
    t.integer  "posted_by_id"
    t.integer  "reviewed_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "posted_by_id"
    t.integer  "critic_id"
    t.integer  "publication_id"
    t.date     "review_date"
    t.text     "text"
    t.float    "score"
    t.string   "link_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "production_id"
    t.boolean  "is_published_site", :default => false
    t.boolean  "is_published_feed", :default => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "theatres", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.text     "address"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reviews", :force => true do |t|
    t.integer  "posted_by_id"
    t.date     "review_date"
    t.text     "text"
    t.float    "score"
    t.integer  "thumbs"
    t.integer  "production_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_conflict"
    t.string   "conflict_details"
    t.integer  "up_vote_count",    :default => 0
    t.integer  "down_vote_count",  :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.integer  "role_id"
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "single_access_token",                   :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",         :default => 0,    :null => false
    t.integer  "failed_login_count",  :default => 0,    :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "allow_emails",        :default => true
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "referrer_email"
    t.boolean  "is_facebook_only"
    t.text     "fb_access_token"
    t.string   "fb_first_name"
    t.string   "fb_last_name"
    t.string   "fb_user_id"
    t.string   "fb_email"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_review_id"
    t.boolean  "up"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
