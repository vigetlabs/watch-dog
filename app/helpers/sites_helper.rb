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
      
      def tier_two_threshold_input(value = nil)
        input(:text, 'site[threshold_tier_two]', site.threshold_tier_two, :id => 'site-threshold_tier_two', 
          :label => '# of Failures for Tier Two Notification')
      end

      def tier_two_email_input(value = nil)
        input(:text, 'site[email_tier_two]', site.email_tier_two, :id => 'site-email_tier_two',
          :label => 'Tier Two Email Address')
      end

      def site_errors
        errors = site.errors.map {|attr, msg| { :message => "#{attr} #{msg}" } }
      end
    end
  end
end
