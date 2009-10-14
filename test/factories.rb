class Options
  def method_missing(method, *args)
    @records ||= {}
    @records[method] = args.first
    @records
  end
end

module Factory
  def factory(options = {}, &block)
    if block_given?
      @default_options = Options.new.instance_eval(&block)
    else
      self.new((@default_options || {}).merge(options))
    end
  end
end

Ohm::Model.extend(Factory)

Site.factory do
  name "Google"
  url "http://google.com"
  match_text "feeling lucky"
  threshold 5
  email "admin@google.com"
end
