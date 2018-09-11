class SearchReviewJob < ApplicationJob
  queue_as :default

  include ApplicationHelper

  def perform(movie)
    movie.review.update(score: analyseNYT(movie.review.body))
  end
end
