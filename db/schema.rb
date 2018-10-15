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

ActiveRecord::Schema.define(version: 20181015192035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.date     "purchase_date"
    t.date     "entry_date"
    t.date     "last_check"
    t.integer  "group_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",            default: 0
    t.integer  "organization",      default: 0
    t.integer  "number",            default: 1
    t.integer  "parent_id"
    t.string   "specific_name"
    t.string   "serial"
    t.string   "location"
    t.string   "at_who"
    t.integer  "condition",         default: 0
    t.date     "warranty"
    t.string   "comment"
    t.string   "inventory_number"
    t.integer  "entry_price"
    t.integer  "accountancy_state", default: 0
    t.index ["group_id"], name: "index_items_on_group_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "item_id"
    t.index ["item_id"], name: "index_photos_on_item_id", using: :btree
  end

  create_table "rights", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "write"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "read_rights"
    t.string   "write_rights"
    t.boolean  "admin"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "read_all_group",  default: false
    t.boolean  "write_all_group", default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
