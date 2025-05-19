# desc "Fill the database tables with some sample data"
# task({ sample_data: :environment }) do
# end

# Option A: make `rake sample_data` depend on the namespaced loader
#desc "Fill the database tables with some sample data"
#task :sample_data => "sample_data:load"

desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

   # Clean up uploaded files
  #FileUtils.rm_rf(Rails.root.join("public", "uploads"))
  #FileUtils.rm_rf(Rails.root.join("public", "event_images"))

  # Wipe out old data
  FollowRequest.destroy_all
  Comment.destroy_all
  Rsvp.destroy_all
  Event.destroy_all
  User.destroy_all

  people = Array.new(10) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
    }
  end

  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "Smith" }
  people << { first_name: "Carol", last_name: "Smith" }
  people << { first_name: "Dave", last_name: "Smith" }
  people << { first_name: "Eve", last_name: "Smith" }

  people.each do |person|
    username = person.fetch(:first_name).downcase
    secret = false

    if ["alice", "carol"].include?(username) || User.where(private: true).count <= 6
      secret = true
    end

    user = User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      name: "#{person[:first_name]} #{person[:last_name]}",
      bio: Faker::Lorem.paragraph(
        sentence_count: 2,
        supplemental: true,
        random_sentences_to_add: 4
      ),
      private: secret,
      avatar_image: File.open("#{Rails.root}/public/avatars/#{rand(1..10)}.jpeg")
    )
  end

  users = User.all

   # Mutual follow requests
  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        status = "accepted"
        if second_user.private?
          status = "pending"
        end
        first_user_follow_request = first_user.sent_follow_requests.create(
          recipient: second_user,
          status: status
        )
      end

      if rand < 0.75
        status = "accepted"
        if first_user.private?
          status = "pending"
        end
        second_user_follow_request = second_user.sent_follow_requests.create(
          recipient: first_user,
          status: status
        )
      end
    end
  end

  # Events, RSVPs & Comments on events
  users.each do |user|
    rand(5..8).times do
      start_at = Time.now + rand(1..14).days + rand(0..23).hours
      end_at   = start_at + rand(1..6).hours

      event = user.own_events.create(
        { :title       => Faker::Lorem.sentence(:word_count => 3),
          :description => Faker::Lorem.paragraph,
          :location    => Faker::Address.city,
          :start_time  => start_at,
          :end_time    => end_at,
          :rsvp_cap    => rand(10..30),
          :image       => File.open(
                           "#{Rails.root}/public/event_images/#{rand(1..10)}.jpeg"
                         )
        }
      )

      # RSVPs
      user.followers.each do |follower|
        if rand < 0.5
          event.rsvps.create({ :attendee_id => follower.id })
        end
      end

      # Comments on events
      user.followers.each do |follower|
        if rand < 0.3
          event.comments.create(
            { :author_id => follower.id,
              :body      => Faker::Lorem.sentence }
          )
        end
      end
    end
  end

 ending = Time.now
  p "Seed finished in #{(ending - starting).to_i} seconds"
  p "Users: #{User.count}"
  p "FollowRequests: #{FollowRequest.count}"
  p "Events: #{Event.count}"
  p "Rsvps: #{Rsvp.count}"
  p "Comments: #{Comment.count}"
end
