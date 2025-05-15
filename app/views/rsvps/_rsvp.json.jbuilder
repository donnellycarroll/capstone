json.extract! rsvp, :id, :attendee_id, :event_id, :created_at, :updated_at
json.url rsvp_url(rsvp, format: :json)
