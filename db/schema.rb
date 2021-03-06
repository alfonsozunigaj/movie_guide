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

ActiveRecord::Schema.define(version: 2018_09_10_232904) do

  create_table "movies", force: :cascade do |t|
    t.integer "tmdb_id"
    t.string "title"
    t.integer "vote_count"
    t.float "vote_average"
    t.text "overview"
    t.string "poster_path"
    t.string "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_seen"
    t.integer "visits"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "critics_pick"
    t.string "headline"
    t.string "summary"
    t.string "url"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "movie_id"
    t.float "score"
    t.text "body"
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.text "content"
    t.string "author"
    t.string "link"
    t.integer "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "score_tag"
    t.index ["movie_id"], name: "index_tweets_on_movie_id"
  end

end
