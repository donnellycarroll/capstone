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
end
