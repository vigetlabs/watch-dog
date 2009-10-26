class MonitCheck < Mustache
  self.path = root_path('app', 'templates')
  self.template_extension = "mustache"
  
  def initialize(site)
    @site = site
  end
  
  def monit_check_name
    @site.monit_check_name
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
  
  def emails
    @site.email.split(/\s*,\s*/).map {|e| {:email => e} }
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
  
  def email
    @site.email
  end
end
