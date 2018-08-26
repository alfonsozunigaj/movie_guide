class ApplicationController < ActionController::Base
  def index
    @now_playing = Tmdb::Movie.now_playing['results']
    @upcomming = Tmdb::Movie.upcoming['results']
    @popular = Tmdb::Movie.popular['results']
    @top_rated = Tmdb::Movie.top_rated['results']
    @movie = Tmdb::Search.movie('The Meg', page: 1)['results']
  end
end
