FactoryGirl.define do
  factory :rating do
    value { rand(1..5) }
  end
end