class Main
  module Views
    class Index < Mustache
      include Main::Helpers::AppHelper

      def sites
        Site.all.map do |site|
          {
            :id => site.id,
            :name => site.name,
            :url => site.url,
            :status => site.status_record
          }
        end
      end
    end
  end
end
