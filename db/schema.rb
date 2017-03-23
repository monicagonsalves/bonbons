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

ActiveRecord::Schema.define(version: 20170323110717) do

  create_table "english_translations", force: :cascade do |t|
    t.string   "from_lang",   limit: 255, null: false
    t.string   "translation", limit: 255, null: false
    t.string   "orig_word",   limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "flashcards", force: :cascade do |t|
    t.string   "translation",        limit: 255, null: false
    t.string   "orig_word",          limit: 255, null: false
    t.string   "gender",             limit: 1,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "language_pair_id",   limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "batch_num",          limit: 4,   null: false
  end

  add_index "flashcards", ["language_pair_id"], name: "fk_rails_0c554c5eab", using: :btree

  create_table "flashcards_stacks", force: :cascade do |t|
    t.integer "flashcard_id", limit: 4, null: false
    t.integer "stack_id",     limit: 4, null: false
  end

  add_index "flashcards_stacks", ["flashcard_id"], name: "index_flashcards_stacks_on_flashcard_id", using: :btree
  add_index "flashcards_stacks", ["stack_id"], name: "index_flashcards_stacks_on_stack_id", using: :btree

  create_table "flashcards_user_defined_tags", force: :cascade do |t|
    t.integer "flashcard_id",        limit: 4, null: false
    t.integer "user_defined_tag_id", limit: 4, null: false
  end

  add_index "flashcards_user_defined_tags", ["flashcard_id"], name: "index_flashcards_user_defined_tags_on_flashcard_id", using: :btree
  add_index "flashcards_user_defined_tags", ["user_defined_tag_id"], name: "index_flashcards_user_defined_tags_on_user_defined_tag_id", using: :btree

  create_table "language_pairs", force: :cascade do |t|
    t.string   "code",       limit: 7,   null: false
    t.string   "from_lang",  limit: 255, null: false
    t.string   "to_lang",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "language_pairs", ["code"], name: "index_language_pairs_on_code", using: :btree

  create_table "stacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_defined_tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_defined_tags", ["name"], name: "index_user_defined_tags_on_name", using: :btree

  add_foreign_key "flashcards", "language_pairs"
end
