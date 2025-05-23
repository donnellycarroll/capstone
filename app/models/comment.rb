# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  event_id   :bigint           not null
#
# Indexes
#
#  index_comments_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (event_id => events.id)
#
class Comment < ApplicationRecord
  belongs_to :event, counter_cache: true
  belongs_to :author, class_name: "User", counter_cache: true

  validates :body, presence: true
end
