json.extract! comment, :id, :event_id, :author_id, :body, :created_at, :updated_at
json.url comment_url(comment, format: :json)
