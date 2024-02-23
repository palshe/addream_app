FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 6)}
    email {"example@example.com"}
    password {"111111"}
    password_confirmation {"111111"}
  end
end