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

ActiveRecord::Schema.define(version: 2019_03_11_112501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "organisation_types", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.bigint "organisation_type_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_type_id"], name: "index_organisations_on_organisation_type_id"
    t.index ["region_id", "organisation_type_id", "name"], name: "ix_orgs_region_org_type_name", unique: true
    t.index ["region_id"], name: "index_organisations_on_region_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policy_areas", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "slug"
    t.string "nuts_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.bigint "person_id"
    t.bigint "organisation_id"
    t.bigint "region_id"
    t.bigint "role_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_roles_on_organisation_id"
    t.index ["person_id", "organisation_id", "region_id", "title"], name: "ix_role_unique_person_org_region_title", unique: true
    t.index ["person_id"], name: "index_roles_on_person_id"
    t.index ["region_id"], name: "index_roles_on_region_id"
    t.index ["role_type_id"], name: "index_roles_on_role_type_id"
    t.index ["slug"], name: "index_roles_on_slug"
    t.index ["title"], name: "index_roles_on_title"
  end

  add_foreign_key "organisations", "organisation_types"
  add_foreign_key "organisations", "regions"
  add_foreign_key "roles", "organisations"
  add_foreign_key "roles", "people"
  add_foreign_key "roles", "regions"
  add_foreign_key "roles", "role_types"
end
