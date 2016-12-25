FactoryGirl.define do
  factory :post do
    title 'Text title'
    content 'Text content'
    author_ip { Faker::Internet.ip_v4_address }
  end
end