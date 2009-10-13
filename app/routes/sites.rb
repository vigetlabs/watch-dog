class Main
  get "/sites/new" do
    mustache :new_site
  end
  
  post '/sites' do
    @site = Site.new(params['site'])
    if @site.save
      
    else
      
    end
  end
end
