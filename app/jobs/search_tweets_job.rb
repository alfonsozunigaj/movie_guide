class SearchTweetsJob < ApplicationJob
  queue_as :default

  include ApplicationHelper

  def perform(movie)
    tweets_title = $twitter_client.search(movie.title, lang: "en", geocode: "37.433810,-81.509156,1000mi")
    $counter = 25
    tweets_title.each do |tweet|
      new_tweet = Tweet.new
      new_tweet.content = tweet.text
      new_tweet.author = tweet.user.screen_name
      new_tweet.movie = movie
      analysis = analyse(tweet.text)
      new_tweet.score_tag = parse_sentiment(analysis['score_tag']).to_s
      if analysis['subjectivity'] == 'SUBJECTIVE' and new_tweet.score_tag != '0'
        if new_tweet.valid?
          $counter -= 1
          new_tweet.save
        end
      end
      if $counter == 0
        puts "Done analysing tweets from " + movie.title
        break
      end
    end
  end
end
