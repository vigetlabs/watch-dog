class Main
  module Views
    class EditSite < Mustache
      include Main::Helpers::AppHelper
      include Main::Helpers::SitesHelper

      attr_reader :site

      def site_id
        site.id
      end

      def name_input
        super(site.name)
      end

      def url_input
        super(site.url)
      end

      def text_match_input
        super(site.match_text)
      end

      def threshold_input
        super(site.threshold)
      end

      def email_input
        super(site.email)
      end
    end
  end
end