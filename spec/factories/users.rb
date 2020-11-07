# This will guess the User class
FactoryBot.define do
  user_first_names = [ "Leo", "Raph", "Mike", "Don" ]
  user_last_names = [ "DaVinci", "di Lodovico Buonarroti Simoni", "Sanzio da Urbino", "di Niccolò di Betto Bardi" ]

  factory :user do
    sequence(:first_name, 0)  { |n| user_first_names[n] }
    sequence(:last_name, 0)   { |n| user_last_names[n] }
    sequence(:email, 0)       { |n| "#{ user_first_names[n] }@example.com" }
    password       { "password" }
    password_confirmation { "password" }
    confirmed_at   { Time.now }
    access_level   { 0 }
  end
end
