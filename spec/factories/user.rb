FactoryBot.define do
  factory :user do
    name { "石井 春輝" }
    email {"example@example.com"}
    password {"111111"}
    password_confirmation {"111111"}
    confirmation_sent_at { Time.zone.now }
    confirmed_at { Time.zone.now }
  end
end