json.extract! todo, :id, :reference, :title, :task, :created_at, :updated_at
json.url todo_url(todo, format: :json)
