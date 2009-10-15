class Main
  module Helpers
    module SitesHelper
      attr_reader :site

      def name_input
        input(:text, 'site[name]', site.name, :id => 'site-name', :label => 'Site Name')
      end

      def url_input(value = nil)
        input(:text, 'site[url]', site.url, :id => 'site-url', :label => 'Site URL')
      end

      def match_text_input(value = nil)
        text_area('site[match_text]', site.match_text, :id => 'site-match_text', :label => 'Text to Match')
      end

      def threshold_input(value = nil)
        input(:text, 'site[threshold]', site.threshold, :id => 'site-threshold', :label => '# of Failures')
      end

      def email_input(value = nil)
        input(:text, 'site[email]', site.email, :id => 'site-email', :label => 'Email Address')
      end

      def site_errors
        errors = site.errors.present do |e|
          e.on [:name, :not_present], "Name should be present"
          e.on [:url, :not_present], "URL should be present"
          e.on [:url, :format], "URL should follow standard format"
          e.on [:threshold, :not_present], "# of retries should be present"
          e.on [:email, :not_present], "Email address should be present"
          e.on [:email, :format], "Email address should follow standard format"
          e.on [:account, :not_present], "You should supply an account"
        end

        errors.map {|e| { :message => e} }
      end
    end
  end
end
