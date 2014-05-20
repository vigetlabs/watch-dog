puts "HERE!"

FactoryGirl.define do
  factory :site do
    name "Google"
    sequence(:url) {|n| "http://www.google.com/intl/en/help/features#{n}.html" }
    match_text "feeling lucky"
    threshold 5
    email "admin@google.com"
  end
end
