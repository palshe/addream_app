FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 6)}
    email {"example@example.com"}
    phone {"1111111111"}
    password {"111111"}
    password_confirmation {"111111"}
    created_at {Time.now}
    activated {true}
    activated_at {Time.now}
  end
end