class Main
  module Views
    class ShowSite < Mustache
      attr_reader :site

      [:name, :url, :match_text, :threshold, :email].each do |attribute|
        define_method("site_#{attribute}") { site.send(attribute) }
      end
    end
  end
end