class Main
  module Helpers
    module AppHelper
      
      def html_escape(s)
        s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
      end
      alias h html_escape
      
      def input(type, name, value = nil, options = {})
        label = options[:label] || name.titlecase
        html_id = options[:name] || name
        <<-HTML
  <p>
    <label for="#{html_id}">#{label}</label>
    <input type="#{type.to_s}" id="#{html_id}" name="#{name}" value="#{h(value.to_s)}" />
  </p>
HTML
      end
      
      def text_area(name, value = nil, options = {})
        label = options[:label] || name.titlecase
        html_id = options[:name] || name
        <<-HTML
  <p>
    <label for="#{html_id}">#{label}</label>
    <textarea name="#{name}" id="#{html_id}">#{h(value.to_s)}</textarea>
  </p>
HTML
      end
      
    end
  end
end
