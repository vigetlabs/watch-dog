class Main
  module Views
    class Index < Mustache
      include Main::Helpers::AppHelper

      def sites
        summaries = Site.statuses

        Site.all.map do |site|
          {
            :id => site.id,
            :name => site.name,
            :url => site.url,
            :status => summaries[site.id]
          }
        end
      end
    end
  end
end
