json.extract! event, :id, :title, :image, :location, :description, :host_id, :start_time, :end_time, :rsvp_cap, :guests_count, :comments_count, :created_at, :updated_at
json.url event_url(event, format: :json)
