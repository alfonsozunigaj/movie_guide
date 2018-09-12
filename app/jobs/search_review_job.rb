class SearchReviewJob < ApplicationJob
  queue_as :default

  include ApplicationHelper

  def perform(movie)
    unless movie.review.nil?
      movie.review.update(score: analyseNYT(movie.review.body))
    end
  end
end
