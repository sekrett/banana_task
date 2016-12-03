FactoryGirl.define do
  factory :comment do
    content "MyText"
    post
    user
  end
end
