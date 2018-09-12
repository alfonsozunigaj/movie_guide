class ApplicationController < ActionController::Base
  require 'uri'
  require 'net/http'

  include ApplicationHelper

  def index
    @now_playing = Tmdb::Movie.now_playing['results']
    @upcomming = Tmdb::Movie.upcoming['results']
    @popular = Tmdb::Movie.popular['results']
    @top_rated = Tmdb::Movie.top_rated['results']
    @most_viewed = Movie.all.order(:visits).reverse.take(20)
  end

  def nyt_review(title)
    uri = URI("https://api.nytimes.com/svc/movies/v2/reviews/search.json")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    uri.query = URI.encode_www_form({
                                        "api-key" => ENV['NYT_API_KEY'],
                                        :query => title
                                    })
    request = Net::HTTP::Get.new(uri.request_uri)
    @result = JSON.parse(http.request(request).body)
    @result.as_json['results'].first
  end

  def save_movie
    checked = Movie.find_by_tmdb_id(params[:id])
    if checked.nil?
      tmdb_id = params[:id]
      title = params[:title]
      vote_count = params[:vote_count]
      vote_average = params[:vote_average]
      overview = params[:overview]
      poster_path = 'http://image.tmdb.org/t/p/w342/' + params[:poster_path]
      release_date = params[:release_date]
      last_seen = DateTime.now
      visits = 0
      @movie = Movie.new(tmdb_id: tmdb_id, title: title, vote_average: vote_average, vote_count: vote_count, overview: overview, poster_path: poster_path, release_date: release_date, last_seen: last_seen, visits: visits)
      if @movie.valid?
        @movie.save

        nyt_info = nyt_review(title)
        unless nyt_info.nil?
          critics_pick = nyt_info['critics_pick']
          headline = nyt_info['headline']
          summary = nyt_info['summary_short']
          url = nyt_info['link']['url']
          movie = @movie
          body = getNYT(url)
          review = Review.new(critics_pick: critics_pick, headline: headline, summary: summary, url: url, movie: movie, body: body)
          if review.valid?
            review.save
            @movie.update(review: review)
          end
        end
=begin
        tweets_title = $twitter_client.search(params[:title], lang: "en", geocode: "37.433810,-81.509156,1000mi")
        $counter = 15
        tweets_title.each do |tweet|
          new_tweet = Tweet.new
          new_tweet.content = tweet.text
          new_tweet.author = tweet.user.screen_name
          new_tweet.movie = @movie
          analysis = analyse(tweet.text)
          puts analysis['subjectivity']
          new_tweet.score_tag = parse_sentiment(analysis['score_tag']).to_s
          if analysis['subjectivity'] == 'SUBJECTIVE' and new_tweet.score_tag != '0'
            if new_tweet.valid?
              $counter -= 1
              puts "SAVED"
              new_tweet.save
            end
          end
          if $counter == 0
            break
          end
        end
=end
        SearchReviewJob.perform_later(@movie)
        SearchTweetsJob.perform_later(@movie)
        redirect_to @movie, notice: 'Movie saved'
      else
        redirect_to root_path, alert: 'Movie could not be saved'
      end
    else
      if checked.review.nil?
        nyt_info = nyt_review(checked.title)
        unless nyt_info.nil?
          critics_pick = nyt_info['critics_pick']
          headline = nyt_info['headline']
          summary = nyt_info['summary_short']
          url = nyt_info['link']['url']
          movie = @movie
          body = getNYT(url)
          review = Review.new(critics_pick: critics_pick, headline: headline, summary: summary, url: url, movie: movie, body: body)
          if review.valid?
            review.save
            checked.update(review: review)
          end
        end
        SearchReviewJob.perform_later(checked)
      elsif checked.review.score == 0.0
        SearchReviewJob.perform_later(checked)
      end
      SearchTweetsJob.perform_later(@movie)
      redirect_to checked
    end
  end

  def results
    @search = params[:search]
    @results = Tmdb::Search.movie(@search)[:results]
  end
end
