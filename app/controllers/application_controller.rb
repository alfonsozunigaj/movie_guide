class ApplicationController < ActionController::Base
  def index
    @now_playing = Tmdb::Movie.now_playing['results']
    @upcomming = Tmdb::Movie.upcoming['results']
    @popular = Tmdb::Movie.popular['results']
    @top_rated = Tmdb::Movie.top_rated['results']
    @movie = Tmdb::Movie.detail(550)
  end

  def save_movie
    checked = Movie.find_by_tmdb_id(params[:id])
    unless checked.nil?
      redirect_to checked, alert: 'Movie already exist'
    else
      @movie = Movie.new
      @movie.tmdb_id = params[:id]
      @movie.title = params[:title]
      @movie.vote_count = params[:vote_count]
      @movie.vote_average = params[:vote_average]
      @movie.overview = params[:overview]
      @movie.poster_path = 'http://image.tmdb.org/t/p/w342/' + params[:poster_path]
      @movie.release_date = params[:release_date]
      if @movie.valid?
        @movie.save
        redirect_to root_path, notice: 'Movie saved'
      else
        redirect_to root_path, alert: 'Movie not saved'
      end
    end
  end
end
