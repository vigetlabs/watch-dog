class Main
  module Views
    class ShowSite < Mustache
      attr_reader :site

      [:id, :name, :url, :threshold, :email].each do |attribute|
        define_method("site_#{attribute}") { site.send(attribute) }
      end
      
      def site_match_text
        site.match_text.empty? ? "No match text" : site.match_text 
      end
    end
  end
end