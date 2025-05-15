
namespace :sample_data do
  desc "Blow away & re-create some dummy Users, Events, Comments, Follows and RSVPs"
  task :load => :environment do
    puts "👉 clearing out old data…"
    Rsvp.delete_all
    FollowRequest.delete_all
    Comment.delete_all
    Event.delete_all
    User.delete_all

    puts "👉 creating users…"
    alice = User.new
    alice.username        = "alice"
    alice.email           = "alice@example.com"
    alice.name            = "Alice Doe"
    alice.avatar_image    = "https://placekitten.com/200/200"
    alice.bio             = "Loves Ruby & pizza"
    alice.private         = false
    alice.password        = "password"
    alice.save!

    bob = User.new
    bob.username          = "bob"
    bob.email             = "bob@example.com"
    bob.name              = "Bob Smith"
    bob.avatar_image      = "https://placekitten.com/201/201"
    bob.bio               = "Event junkie"
    bob.private           = false
    bob.password          = "password"
    bob.save

    carol = User.new
    carol.username        = "carol"
    carol.email           = "carol@example.com"
    carol.name            = "Carol Jones"
    carol.avatar_image    = "https://placekitten.com/202/202"
    carol.bio             = "Coffee & code"
    carol.private         = true
    carol.password        = "password"
    carol.save

    puts "👉 creating events…"
    meetup = Event.new
    meetup.title          = "Rails Meetup"
    meetup.image          = "https://placekitten.com/600/300"
    meetup.location       = "123 Main St"
    meetup.description    = "Come chat about Rails 7!"
    meetup.host_id        = alice.id
    meetup.start_time     = DateTime.now + 2.days
    meetup.end_time       = DateTime.now + 2.days + 3.hours
    meetup.rsvp_cap       = 50
    meetup.guests_count   = 0
    meetup.comments_count = 0
    meetup.save

    hackathon = Event.new
    hackathon.title       = "Weekend Hackathon"
    hackathon.image       = "https://placekitten.com/601/300"
    hackathon.location    = "Tech Loft"
    hackathon.description = "Build something awesome"
    hackathon.host_id     = bob.id
    hackathon.start_time  = DateTime.now + 7.days
    hackathon.end_time    = DateTime.now + 8.days
    hackathon.rsvp_cap    = 100
    hackathon.guests_count   = 0
    hackathon.comments_count = 0
    hackathon.save

    puts "👉 creating comments…"
    c1 = Comment.new
    c1.event_id  = meetup.id
    c1.author_id = bob.id
    c1.body      = "Can’t wait!"
    c1.save

    c2 = Comment.new
    c2.event_id  = meetup.id
    c2.author_id = carol.id
    c2.body      = "Sounds great!"
    c2.save

    puts "👉 creating follow requests…"
    fr1 = FollowRequest.new
    fr1.sender_id    = bob.id
    fr1.recipient_id = alice.id
    fr1.status       = "accepted"
    fr1.save

    fr2 = FollowRequest.new
    fr2.sender_id    = carol.id
    fr2.recipient_id = alice.id
    fr2.status       = "pending"
    fr2.save

    puts "👉 creating RSVPs…"
    r1 = Rsvp.new
    r1.attendee_id = bob.id
    r1.event_id    = meetup.id
    r1.save

    r2 = Rsvp.new
    r2.attendee_id = carol.id
    r2.event_id    = hackathon.id
    r2.save

    puts "✅ sample data loaded!"
  end
end
