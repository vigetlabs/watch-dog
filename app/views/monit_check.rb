class MonitCheck < Mustache
  path = root_path('app', 'templates')
  template_extension = "mustache"
  
  attr_reader :site
  
  def watch_dog_host
    settings :host_name
  end
  
  def site_name
    site.name
  end
  
  def method_missing(name, *args, &block)
    if site.respond_to?(name)
      site.send(name)
    else
      super
    end
  end
end
