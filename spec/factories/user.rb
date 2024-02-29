FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 6)}
    email {"example@example.com"}
    phone {"11111111111"}
    password {"111111"}
    password_confirmation {"111111"}
    activated {true}
    activated_at {Time.zone.now}
  end
end