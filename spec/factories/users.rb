FactoryGirl.define do
  factory :user do
    login { Faker::Name.first_name }
  end
end