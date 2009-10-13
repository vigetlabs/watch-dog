class Main
  module Helpers
    module SitesHelper
      
      def name_input(value = nil)
        input(:text, 'site[name]', value, :id => 'site-name', :label => 'Site Name')
      end
      
      def url_input(value = nil)
        input(:text, 'site[url]', value, :id => 'site-url', :label => 'Site URL')
      end
      
      def text_match_input(value = nil)
        text_area('site[match_text]', value, :id => 'site-match_text', :label => 'Text to Match')
      end
      
      def threshold_input(value = nil)
        input(:text, 'site[threshold]', value, :id => 'site-threshold', :label => '# of Failures')
      end
      
      def email_input(value = nil)
        input(:text, 'site[email]', value, :id => 'site-email', :label => 'Email Address')
      end
      
    end
  end
end
