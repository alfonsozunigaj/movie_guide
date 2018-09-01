class Movie < ApplicationRecord
  has_many :tweets
  has_one :review
  validates :tmdb_id, uniqueness: true
end
