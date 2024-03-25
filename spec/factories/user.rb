FactoryBot.define do
  factory :user do
    id {1}
    name { Faker::Lorem.characters(number: 6)}
    email {"example@example.com"}
    phone {nil}
    password {"111111"}
    password_confirmation {"111111"}
    created_at {Time.zone.now}
    activated {true}
    activated_at {Time.zone.now}
  end
end