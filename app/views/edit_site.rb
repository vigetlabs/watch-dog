class Main
  module Views
    class EditSite < Mustache
      include Main::Helpers::AppHelper
      include Main::Helpers::SitesHelper

      def site_id
        site.id
      end
    end
  end
end