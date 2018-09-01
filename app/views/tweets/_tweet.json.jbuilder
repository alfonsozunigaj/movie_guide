json.extract! tweet, :id, :content, :author, :link, :movie_id, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
