FactoryGirl.define do
  factory :post do
    title "MyString"
    content "MyText"
    published_at "2016-11-28 13:45:20"
    user
  end
end
