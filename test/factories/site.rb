Factory.sequence :url do |n|
  "http://www.google.com/intl/en/help/features.html?rand=#{n}"
end

Factory.define :site do |s|
  s.name "Google"
  s.url { Factory.next(:url) }
  s.match_text "feeling lucky"
  s.threshold 5
  s.email "admin@google.com"
end
