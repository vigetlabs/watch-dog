class Main
  module Views
    class Index < Mustache
      include Main::Helpers::AppHelper

      def sites
        Site.all.map do |site|
          {
            :id => site.id,
            :name => site.name,
            :status => site.latest_status
          }
        end
      end
    end
  end
end
