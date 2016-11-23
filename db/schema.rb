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

ActiveRecord::Schema.define(version: 20161123164819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "food_units", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "weight_per_unit", null: false
    t.integer  "food_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name",               null: false
    t.decimal  "weight",             null: false
    t.decimal  "calorie",            null: false
    t.decimal  "carbohydrate"
    t.decimal  "protein"
    t.decimal  "fat"
    t.decimal  "sugars"
    t.decimal  "sodium"
    t.decimal  "cholesterol"
    t.decimal  "saturated_fat"
    t.decimal  "trans_fat"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "foods", ["name"], name: "index_foods_on_name", unique: true, using: :btree

  create_table "kakao_users", force: :cascade do |t|
    t.string   "user_key",                            null: false
    t.boolean  "active",               default: true, null: false
    t.string   "sex"
    t.integer  "age"
    t.integer  "height"
    t.integer  "weight"
    t.integer  "consumed_calories"
    t.integer  "recommended_calories"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "kakao_users", ["user_key"], name: "index_kakao_users_on_user_key", using: :btree

  create_table "meal_foods", force: :cascade do |t|
    t.integer  "meal_id",                         null: false
    t.integer  "food_id",                         null: false
    t.integer  "food_unit_id",                    null: false
    t.integer  "count",                           null: false
    t.integer  "calorie_consumption", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "meal_foods", ["meal_id"], name: "index_meal_foods_on_meal_id", using: :btree

  create_table "meals", force: :cascade do |t|
    t.integer  "kakao_user_id",                         null: false
    t.integer  "total_calorie_consumption", default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "meals", ["kakao_user_id"], name: "index_meals_on_kakao_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "api_token",              default: ""
  end

  add_index "users", ["api_token"], name: "index_users_on_api_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
