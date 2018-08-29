class Movie < ApplicationRecord
  validates :tmdb_id, uniqueness: true
end
