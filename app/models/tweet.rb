class Tweet < ApplicationRecord
  belongs_to :movie
  validates :content, uniqueness: true
end
