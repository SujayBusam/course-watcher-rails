FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :course do
    subject "COSC"
    number 10
    section 1
  end
end