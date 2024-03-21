# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_21_212340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "purchase_date"
    t.date "entry_date"
    t.date "last_check"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number", default: 1
    t.integer "parent_id"
    t.string "specific_name"
    t.string "serial"
    t.string "location"
    t.string "at_who"
    t.date "warranty"
    t.string "comment"
    t.string "inventory_number"
    t.integer "entry_price"
    t.string "status"
    t.string "condition"
    t.string "accountancy_state"
    t.string "organization"
    t.index ["accountancy_state"], name: "index_items_on_accountancy_state"
    t.index ["condition"], name: "index_items_on_condition"
    t.index ["group_id"], name: "index_items_on_group_id"
    t.index ["status"], name: "index_items_on_status"
  end

  create_table "rights", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "write"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_attributes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.index ["name"], name: "index_system_attributes_on_name", unique: true
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "client_id"
    t.string "user_agent", limit: 512
    t.string "ip_address"
    t.datetime "last_used", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_user_sessions_on_client_id"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_all_group", default: false
    t.boolean "write_all_group", default: false
    t.datetime "last_sign_in_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "rights", "groups"
  add_foreign_key "rights", "users"
  add_foreign_key "user_sessions", "users"
end
