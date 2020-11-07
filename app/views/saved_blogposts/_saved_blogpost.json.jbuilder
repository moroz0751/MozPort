json.extract! saved_blogpost, :id, :user_id, :blogpost_id, :created_at, :updated_at
json.url saved_blogpost_url(saved_blogpost, format: :json)
