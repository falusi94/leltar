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

ActiveRecord::Schema[7.1].define(version: 2025_02_09_211716) do
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

  create_table "department_users", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "department_id", null: false
    t.boolean "write", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "depreciation_configs", force: :cascade do |t|
    t.string "depreciation_method", null: false
    t.integer "depreciation_frequency_value", null: false
    t.string "depreciation_frequency_unit", null: false
    t.boolean "automatic_depreciation", null: false
    t.integer "automatic_depreciation_useful_life", null: false
    t.integer "automatic_depreciation_salvage_value", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_depreciation_configs_on_organization_id", unique: true
  end

  create_table "depreciation_details", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "useful_life", null: false
    t.integer "entry_value", null: false
    t.date "entry_date", null: false
    t.integer "book_value", null: false
    t.integer "salvage_value", null: false
    t.string "depreciation_method", null: false
    t.string "depreciation_frequency_unit", null: false
    t.integer "depreciation_frequency_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_depreciation_details_on_item_id"
  end

  create_table "depreciation_entries", force: :cascade do |t|
    t.bigint "depreciation_details_id", null: false
    t.date "period_start_date", null: false
    t.date "period_end_date", null: false
    t.integer "depreciation_expense", null: false
    t.integer "accumulated_depreciation", null: false
    t.integer "book_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["depreciation_details_id"], name: "index_depreciation_entries_on_depreciation_details_id"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.date "acquisition_date"
    t.date "entry_date"
    t.date "last_check"
    t.integer "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count", default: 1
    t.integer "parent_id"
    t.string "serial_number"
    t.date "warranty_end_at"
    t.string "inventory_number"
    t.integer "entry_price"
    t.string "status"
    t.string "condition"
    t.string "accountancy_state"
    t.bigint "location_id"
    t.string "acquisition_type"
    t.index ["accountancy_state"], name: "index_items_on_accountancy_state"
    t.index ["condition"], name: "index_items_on_condition"
    t.index ["department_id"], name: "index_items_on_department_id"
    t.index ["description"], name: "index_items_on_description"
    t.index ["inventory_number"], name: "index_items_on_inventory_number"
    t.index ["location_id"], name: "index_items_on_location_id"
    t.index ["name"], name: "index_items_on_name"
    t.index ["serial_number"], name: "index_items_on_serial_number"
    t.index ["status"], name: "index_items_on_status"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.string "role_name", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["role_name"], name: "index_organization_users_on_role_name"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "currency_code", null: false
    t.string "slug", null: false
    t.date "fiscal_period_starts_at"
    t.string "fiscal_period_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug"
  end

  create_table "system_attributes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
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
    t.datetime "last_sign_in_at"
    t.bigint "last_organization_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_organization_id"], name: "index_users_on_last_organization_id"
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
  add_foreign_key "department_users", "departments"
  add_foreign_key "department_users", "users"
  add_foreign_key "depreciation_configs", "organizations"
  add_foreign_key "depreciation_details", "items"
  add_foreign_key "depreciation_entries", "depreciation_details", column: "depreciation_details_id"
  add_foreign_key "locations", "organizations"
  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "users", "organizations", column: "last_organization_id"
end
