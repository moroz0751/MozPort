json.extract! blogpost, :id, :title, :body, :created_at, :updated_at
json.url blogpost_url(blogpost, format: :json)
