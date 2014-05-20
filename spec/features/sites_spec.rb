require 'spec_helper'

describe "Managing sites", :type => :feature do
  describe "I should be able to visit the home page which is a list of sites" do
    it "A visitor goes to the root URL" do
      site = create(:site)
      visit "/"

      page.should have_content "Watchdog"
      page.should have_content site.name
      page.should have_content "Add Site to Watch"
    end

    it "A visitor goes to the sites list" do
      site = create(:site)

      visit "/sites"

      page.should have_content "Watchdog"
      page.should have_content site.name
      page.should have_content "Add Site to Watch"
    end
  end

  describe "I should be able to create a new Site to watch" do
    it "A user goes to the new site page" do
      visit "/sites/new"

      page.should have_content "New Site"

      page.should have_css 'form input[name="site[name]"]'
      page.should have_css 'form input[name="site[url]"]'
      page.should have_css 'form textarea[name="site[match_text]"]'
      page.should have_css 'form input[name="site[threshold]"]'
      page.should have_css 'form input[name="site[email]"]'
    end

    it "A user submits valid site information" do
      visit "/sites/new"
      fill_in "site-name", :with => "Google"
      fill_in "site-url", :with => "http://google.com/search?q=#{rand(9999)}"
      fill_in "site-match_text", :with => "xxxxx"
      fill_in "site-threshold", :with => "5"
      fill_in "site-email", :with => "admin@google.com"
      click_button "add"
      
      page.should_not have_css 'form input[type="text"]'
      page.should have_content "admin@google.com"
    end

    it "A user submits invalid site information" do
      visit "/sites/new"
      fill_in "site-name", :with => "Google"
      fill_in "site-url", :with => ""
      fill_in "site-match_text", :with => "xxxxx"
      fill_in "site-threshold", :with => "5"
      fill_in "site-email", :with => "admin@google.com"
      click_button "add"

      page.should have_css 'form input[value="admin@google.com"]'
    end
  end

  describe "I should be able to view details about a site" do
    it "A user goes to the site page" do
      site = create(:site)
      visit "/sites/#{site.id}"
      page.should have_content "feeling lucky"
    end
  end

  describe "I should be able to edit details about a site" do
    it "A user goes to the site edit page" do
      site = create(:site)
      visit "/sites/#{site.id}/edit"
      page.should have_css 'form textarea[name="site[match_text]"]'
      page.should have_content "feeling lucky"
    end

    it "A user updates a site record" do
      site = create(:site)
      visit "/sites/#{site.id}/edit"
      fill_in "site-email", :with => "newuser@example.com"
      click_button "save"

      page.should_not have_css 'form input[type="text"]'
      page.should have_content "newuser@example.com"
      page.should have_content "feeling lucky"
    end

    it "A user updates a site record with invalid data" do
      site = create(:site)
      visit "/sites/#{site.id}/edit"
      fill_in "site-email", :with => "xxxxx"
      click_button "save"

      page.should_not have_content "xxxxx"
      page.should have_css "form"
    end
  end

  describe "I should be able to delete a site" do
    it "A user goes to a site page and hits delete" do
      site = create(:site, :name => "Yahoo")
      visit "/sites/#{site.id}"
      click_button "delete"
      
      Site.find_by_id(site.id).should be_nil
      page.should_not have_content "Yahoo"
    end
  end

  after do
    FileUtils.rm_f(Dir["monitrc/#{RACK_ENV}/*.monitrc"])
  end
end
