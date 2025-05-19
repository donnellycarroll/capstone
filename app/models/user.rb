# == Schema Information
#
# Table name: users
#
#  id                             :bigint           not null, primary key
#  avatar_image                   :string
#  bio                            :string
#  comments_count                 :integer          default(0)
#  email                          :citext           default(""), not null
#  encrypted_password             :string           default(""), not null
#  events_count                   :integer          default(0)
#  name                           :string
#  private                        :boolean          default(TRUE)
#  received_friend_requests_count :integer          default(0)
#  remember_created_at            :datetime
#  reset_password_sent_at         :datetime
#  reset_password_token           :string
#  rsvps_count                    :integer          default(0)
#  sent_friend_requests_count     :integer          default(0)
#  username                       :citext
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many  :own_events, class_name: "Event", foreign_key: "host_id"
  
  has_many  :comments, foreign_key: "author_id"
 
  has_many  :rsvps, foreign_key: :attendee_id

  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :accepted_sent_follow_requests, -> { where(status: "accepted") }, foreign_key: :sender_id, class_name: "FollowRequest" #this doesnt work

  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"
  has_many :accepted_received_follow_requests, -> { where(status: "accepted") }, foreign_key: :recipient_id, class_name: "FollowRequest" #this doesnt work

  

  has_many :rsvped_events, through: :rsvps, source: :event

  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient
  has_many :leaders_of_leaders, through: :leaders, source: :leaders

  has_many :followers, through: :accepted_received_follow_requests, source: :sender

  has_many :feed, through: :leaders, source: :own_events

  has_many :discover, -> { distinct }, through: :leaders, source: :rsvped_events

  # I.   events hosted by my leaders
  has_many :events_hosted_by_leaders, through: :leaders, source: :own_events

  # II.  events my leaders attend
  has_many :leaders_rsvps, -> { distinct }, through: :leaders, source: :rsvps 
  has_many :events_attended_by_leaders, -> { distinct }, through: :leaders_rsvps, source: :event

  # III. events my leaders’ leaders attend
  has_many :leaders_of_leaders_rsvps, -> { distinct }, through: :leaders_of_leaders, source: :rsvps 
  has_many :events_attended_by_leaders_of_leaders, -> { distinct }, through: :leaders_of_leaders_rsvps, source: :event #this doesnt work yet or i dont have enough sample data

  validates :username, presence: true, uniqueness: true

end
