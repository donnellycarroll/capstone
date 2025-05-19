# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  comments_count :integer          default(0)
#  description    :string
#  end_time       :datetime
#  guests_count   :integer          default(0)
#  image          :string
#  location       :string
#  rsvp_cap       :integer
#  rsvps_count    :integer          default(0)
#  start_time     :datetime
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  host_id        :bigint           not null
#
# Indexes
#
#  index_events_on_host_id  (host_id)
#
# Foreign Keys
#
#  fk_rails_...  (host_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :host, class_name: "User", counter_cache: true
  
  has_many  :comments
  has_many  :rsvps
  # has_many  :guests, class_name: "Rsvp", foreign_key: :attendee_id
  has_many :attendees, through: :rsvps

  has_many :leaders_of_leaders_events, through: :leaders_of_leaders, source: :own_events

  validates :title, presence: true
  validates :location, presence: true
  validates :start_time, presence: true

  scope :this_week, -> { where(start_time: Time.current..1.week.from_now) }

  after_create :rsvp_to_event #look this up later (callbacks)

  def rsvp_to_event
   rsvps.create(attendee_id: host_id)
  end



end
