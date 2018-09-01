json.extract! review, :id, :critics_pick, :headline, :summary, :url, :image, :created_at, :updated_at
json.url review_url(review, format: :json)
