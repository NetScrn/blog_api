ips = Array.new
50.times do
  ips << Faker::Internet.ip_v4_address
end
logins = Array.new
100.times do
  logins << Faker::Name.first_name
end

200000.times do |n|
  creator = PostCreator.build title: Faker::Lorem.sentence,
                              content: Faker::Lorem.paragraph(20),
                              author_ip: ips.sample,
                              author_login: logins.sample
  creator.save
  if rand(2).zero?
    rater = PostRater.build(creator.post.id, rand(1..5))
    rater.save
  end
  p n+1
end

