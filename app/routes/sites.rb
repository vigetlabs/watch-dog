class Main
  get %r{^/(sites)?$} do
    mustache :index
  end

  get "/sites/new" do
    @site = Site.new
    mustache :new_site
  end

  post '/sites' do
    @site = Site.new(params['site'])
    if @site.save
      redirect "/sites/#{@site.id}"
    else
      mustache :new_site
    end
  end

  get "/sites/:id" do
    @site = Site.find(params[:id])
    mustache :show_site
  end

  get "/sites/:id/edit" do
    @site = Site.find(params[:id])
    mustache :edit_site
  end

  put "/sites/:id" do
    @site = Site.find(params[:id])
    if @site.update_attributes(params[:site])
      redirect "/sites/#{@site.id}"
    else
      mustache :edit_site
    end
  end

  delete "/sites/:id" do
    Site.find(params[:id]).destroy
    redirect '/'
  end
  
  get '/watchdog.css' do
    content_type "text/css"
    scss :stylesheet
  end
end
