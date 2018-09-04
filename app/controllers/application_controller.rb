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
      @movie = Movie.new
      @movie.tmdb_id = params[:id]
      @movie.title = params[:title]
      @movie.vote_count = params[:vote_count]
      @movie.vote_average = params[:vote_average]
      @movie.overview = params[:overview]
      @movie.poster_path = 'http://image.tmdb.org/t/p/w342/' + params[:poster_path]
      @movie.release_date = params[:release_date]
      @movie.last_seen = DateTime.now
      @movie.visits = 0
      if @movie.valid?
        @movie.save

        tweets_title = $twitter_client.search(params[:title], lang: "en", geocode: "37.433810,-81.509156,1000mi").take(30)
        puts tweets_title.as_json
        tweets_title.each do |tweet|
          new_tweet = Tweet.new
          new_tweet.content = tweet.text
          new_tweet.author = tweet.user.screen_name
          new_tweet.movie = @movie
          analysis = analyse(tweet.text).to_s
          parsed_json = ActiveSupport::JSON.decode(analysis)
          new_tweet.score_tag = parsed_json['score_tag']
          if new_tweet.valid?
            new_tweet.save
          end
        end

        nyt_info = nyt_review(params[:title])
        unless nyt_info.nil?
          review = Review.new
          review.critics_pick = nyt_info['critics_pick']
          review.headline = nyt_info['headline']
          review.summary = nyt_info['summary_short']
          review.url = nyt_info['link']['url']
          # review.image = nyt_info['multimedia']['src']
          review.movie = @movie
          if review.valid?
            review.save
            @movie.review = review
          end
        end

        redirect_to @movie, notice: 'Movie saved'
      else
        redirect_to root_path, alert: 'Movie could not be saved'
      end
    else
      redirect_to checked
    end
  end

  def results
    @search = params[:search]
    @results = Tmdb::Search.movie(@search)[:results]
  end
end
