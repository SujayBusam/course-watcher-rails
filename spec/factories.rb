FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end