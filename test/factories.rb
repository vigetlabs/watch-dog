Site.factory do
{
  :name       =>  "Google",
  :url        =>  "http://www.google.com/intl/en/help/features.html?rand=#{rand(9999)}",
  :match_text =>  "feeling lucky",
  :threshold  =>  5,
  :email      =>  "admin@google.com"
}  
end
