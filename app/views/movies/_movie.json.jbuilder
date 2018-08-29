json.extract! movie, :id, :tmdb_id, :title, :vote_count, :vote_average, :overview, :poster_path, :release_date, :created_at, :updated_at
json.url movie_url(movie, format: :json)
