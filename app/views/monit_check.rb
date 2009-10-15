class MonitCheck < Mustache
  self.path = root_path('app', 'templates')
  self.template_extension = "mustache"
  
  def initialize(site)
    @site = site
  end
  
  def watch_dog_host
    settings :host_name
  end
  
  def curl_bin_dir
    settings :curl_bin_dir
  end
  
  def site_name
    @site.name
  end
  
  def host_name
    @site.host
  end
  
  def url
    @site.url
  end
  
  def threshold
    @site.threshold
  end
  
  def match_text?
    !@site.match_text.blank?
  end
  
  def match_text
    @site.match_text
  end
  
  def site_id
    @site.id
  end
  
  def email
    @site.email
  end
end
