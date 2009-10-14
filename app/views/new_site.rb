class Main
  module Views
    class NewSite < Mustache
      include Main::Helpers::AppHelper
      include Main::Helpers::SitesHelper
    end
  end
end
