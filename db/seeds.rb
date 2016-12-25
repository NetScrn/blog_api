ips = Array.new

50.times do
  ips << Faker::Internet.ip_v4_address
end

100.times do
  User.create! login: Faker::Name.first_name
end

2000.times do |n|
  Post.create! title: Faker::Lorem.sentence,
               content: Faker::Lorem.paragraph(20),
               author_ip: ips.sample,
               user_id: rand(1..100)
  p n
end