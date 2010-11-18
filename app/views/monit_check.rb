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
  
  def tier_two?
    !@site.email_tier_two.blank? && !@site.threshold_tier_two.blank?
  end
  
  def threshold_tier_two
    @site.threshold_tier_two
  end
  
  def emails_tier_two
    unless @site.email_tier_two.blank?
      @site.email_tier_two.split(/\s*,\s*/).map {|e| {:email => e} }
    else
      []
    end
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
