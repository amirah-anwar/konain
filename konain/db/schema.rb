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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160630174752) do

  create_table "attachments", force: :cascade do |t|
    t.string   "imageable_type",     limit: 255, null: false
    t.integer  "imageable_id",       limit: 4,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  add_index "attachments", ["imageable_id", "imageable_type"], name: "index_attachments_on_imageable_id_and_imageable_type", using: :btree

  create_table "banners", force: :cascade do |t|
    t.string   "name",               limit: 100
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "page_id",            limit: 4
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "sender_name", limit: 255
    t.integer  "agent_id",    limit: 4,     null: false
    t.text     "body",        limit: 65535
    t.string   "contact",     limit: 255
    t.string   "user_email",  limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "emails", ["agent_id"], name: "index_emails_on_agent_id", using: :btree

  create_table "favourites", force: :cascade do |t|
    t.string   "favourited_type", limit: 255, null: false
    t.integer  "favourited_id",   limit: 4,   null: false
    t.integer  "user_id",         limit: 4,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "favourites", ["favourited_type", "favourited_id"], name: "index_favourites_on_favourited_type_and_favourited_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.text     "content",    limit: 65535
    t.string   "permalink",  limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "pages", ["name"], name: "index_pages_on_name", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title",       limit: 30,                                             null: false
    t.text     "description", limit: 65535
    t.string   "city",        limit: 255,                                            null: false
    t.string   "country",     limit: 255,                                            null: false
    t.string   "location",    limit: 60,                                             null: false
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.decimal  "latitude",                  precision: 16, scale: 13
    t.decimal  "longitude",                 precision: 16, scale: 13
    t.boolean  "delta",                                               default: true, null: false
  end

  add_index "projects", ["city"], name: "index_projects_on_city", using: :btree
  add_index "projects", ["country"], name: "index_projects_on_country", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "category",          limit: 30,                                                  null: false
    t.string   "city",              limit: 60,                                                  null: false
    t.string   "title",             limit: 255,                                                 null: false
    t.text     "description",       limit: 65535
    t.integer  "price",             limit: 8,                               default: 0,         null: false
    t.float    "land_area",         limit: 24,                                                  null: false
    t.string   "area_unit",         limit: 20,                                                  null: false
    t.integer  "bedroom_count",     limit: 4,                               default: 0,         null: false
    t.integer  "bathroom_count",    limit: 4,                               default: 0,         null: false
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
    t.integer  "user_id",           limit: 4,                                                   null: false
    t.decimal  "latitude",                        precision: 16, scale: 13
    t.decimal  "longitude",                       precision: 16, scale: 13
    t.boolean  "delta",                                                     default: true,      null: false
    t.boolean  "featured",                                                  default: false,     null: false
    t.datetime "featured_at"
    t.string   "property_type",     limit: 100,                                                 null: false
    t.string   "property_sub_type", limit: 100,                                                 null: false
    t.string   "property_features", limit: 255
    t.string   "state",             limit: 255,                             default: "pending", null: false
    t.integer  "agent_id",          limit: 4
    t.integer  "project_id",        limit: 4
    t.datetime "closed_at"
    t.integer  "end_price",         limit: 8,                               default: 0,         null: false
  end

  add_index "properties", ["agent_id"], name: "index_properties_on_agent_id", using: :btree
  add_index "properties", ["bathroom_count"], name: "index_properties_on_bathroom_count", using: :btree
  add_index "properties", ["bedroom_count"], name: "index_properties_on_bedroom_count", using: :btree
  add_index "properties", ["city"], name: "index_properties_on_city", using: :btree
  add_index "properties", ["closed_at"], name: "index_properties_on_closed_at", using: :btree
  add_index "properties", ["end_price"], name: "index_properties_on_end_price", using: :btree
  add_index "properties", ["price"], name: "index_properties_on_price", using: :btree
  add_index "properties", ["project_id"], name: "index_properties_on_project_id", using: :btree
  add_index "properties", ["property_sub_type"], name: "index_properties_on_property_sub_type", using: :btree
  add_index "properties", ["property_type"], name: "index_properties_on_property_type", using: :btree
  add_index "properties", ["state"], name: "index_properties_on_state", using: :btree
  add_index "properties", ["user_id"], name: "index_properties_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "title",      limit: 20,                 null: false
    t.boolean  "apply",                 default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "tickers", force: :cascade do |t|
    t.string   "title",      limit: 20,  null: false
    t.text     "content",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "name",                   limit: 50,                    null: false
    t.boolean  "is_agent",                             default: false, null: false
    t.string   "mobile_phone_code",      limit: 10,                    null: false
    t.string   "mobile_phone_number",    limit: 20,                    null: false
    t.string   "home_phone_code",        limit: 10,                    null: false
    t.string   "home_phone_number",      limit: 20,                    null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "oauth_token",            limit: 255
    t.datetime "oauth_expires_at"
    t.boolean  "subscriber"
    t.boolean  "admin",                                default: false, null: false
    t.text     "agent_description",      limit: 65535
    t.string   "fax_number",             limit: 20
    t.string   "fax_code",               limit: 10
    t.string   "city",                   limit: 50
    t.string   "country",                limit: 50
    t.string   "zip_code",               limit: 15
    t.string   "address",                limit: 255
    t.boolean  "lawyer",                               default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
