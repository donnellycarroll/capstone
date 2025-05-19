# == Schema Information
#
# Table name: rsvps
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  attendee_id :bigint           not null
#  event_id    :bigint           not null
#
# Indexes
#
#  index_rsvps_on_attendee_id  (attendee_id)
#  index_rsvps_on_event_id     (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (attendee_id => users.id)
#  fk_rails_...  (event_id => events.id)
#
class Rsvp < ApplicationRecord
  belongs_to :attendee, class_name: "User", counter_cache: true
  belongs_to :event, counter_cache: true
  # belongs_to :activity, class_name: "Event", foreign_key: "event_id", counter_cache: :guests_count
end
