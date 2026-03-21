exit unless Rails.env.development?

###########################
#   SEEDS CONFIGURATION   #
###########################

c = {
  number_of_users: 50,
  max_number_of_posts_per_user: 15,
  max_number_of_comments_per_post: 5,
  max_number_of_likes_per_post: 20
}

###########################
#          USERS          #
###########################

print "Creating users... "
c[:number_of_users].times do
  email = Faker::Internet.unique.email

  User.find_or_create_by!(email:) do |user|
    user.name = Faker::Name.name
    user.password = Faker::Internet.password
  end
end
puts "#{c[:number_of_users]} users created."

###########################
#          POSTS          #
###########################

print "Creating posts... "
total_posts = User.includes(:posts).reduce(0) do |total_posts, user|
  number_of_posts = rand(0..c[:max_number_of_posts_per_user])

  number_of_posts.times do
    body = Faker::Lorem.paragraph(random_sentences_to_add: 3)

    user.posts.find_or_create_by!(body:) do |post|
      post.created_at = Faker::Time.between(from: Time.current.midnight - 1.week, to: Time.current)
      post.updated_at = post.created_at
    end
  end

  total_posts + number_of_posts
end
puts "#{total_posts} posts created."

###########################
#        COMMENTS         #
###########################

print "Creating comments... "
total_comments = Post.includes(:user, :comments).reduce(0) do |total_comments, post|
  number_of_comments = rand(0..c[:max_number_of_comments_per_post])

  number_of_comments.times do
    body = Faker::Lorem.sentence(random_words_to_add: 3)

    post.comments.find_or_create_by!(body:) do |comment|
      comment.user = User.excluding(post.user).sample
      comment.created_at = Faker::Time.between(from: post.created_at, to: Time.current)
      comment.updated_at = comment.created_at
    end
  end

  total_comments + number_of_comments
end
puts "#{total_comments} comments created."

###########################
#          LIKES          #
###########################

users = User.all

print "Creating likes... "
total_likes = Post.includes(:likes).reduce(0) do |total_likes, post|
  number_of_likes = rand(0..c[:max_number_of_likes_per_post])

  number_of_likes.times do
    user = users.sample
    post.likes.find_or_create_by!(user:)
  end

  total_likes + number_of_likes
end
puts "#{total_likes} likes created."
