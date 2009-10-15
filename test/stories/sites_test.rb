require "stories_helper"

class SitesTest < Test::Unit::TestCase
  story "I should be able to visit the home page which is a list of sites" do
    scenario "A visitor goes to the root URL" do
      site = Site.factory.save

      visit "/"

      assert_contain "Watch Dog"
      assert_contain site.name
      assert_contain "Add Site to Watch"
    end

    scenario "A visitor goes to the sites list" do
      site = Site.factory.save

      visit "/sites"

      assert_contain "Watch Dog"
      assert_contain site.name
      assert_contain "Add Site to Watch"
    end
  end

  story "I should be able to create a new Site to watch" do
    scenario "A user goes to the new site page" do
      visit "/sites/new"

      assert_contain "Setup a New Site to Watch"

      assert_have_selector 'form input[name="site[name]"]'
      assert_have_selector 'form input[name="site[url]"]'
      assert_have_selector 'form textarea[name="site[match_text]"]'
      assert_have_selector 'form input[name="site[threshold]"]'
      assert_have_selector 'form input[name="site[email]"]'
    end

    scenario "A user submits valid site information" do
      visit "/sites/new"
      fill_in "site-name", :with => "Google"
      fill_in "site-url", :with => "http://google.com/search?q=#{rand(9999)}"
      fill_in "site-match_text", :with => "xxxxx"
      fill_in "site-threshold", :with => "5"
      fill_in "site-email", :with => "admin@google.com"
      click_button "add"

      assert_have_no_selector "form"
      assert_contain "admin@google.com"
    end

    scenario "A user submits invalid site information" do
      visit "/sites/new"
      fill_in "site-name", :with => "Google"
      fill_in "site-url", :with => ""
      fill_in "site-match_text", :with => "xxxxx"
      fill_in "site-threshold", :with => "5"
      fill_in "site-email", :with => "admin@google.com"
      click_button "add"

      assert_have_selector 'form input[value="admin@google.com"]'
    end
  end

  story "I should be able to view details about a site" do
    scenario "A user goes to the site page" do
      site = Site.factory.save
      visit "/sites/#{site.id}"
      assert_contain "feeling lucky"
    end
  end

  story "I should be able to edit details about a site" do
    scenario "A user goes to the site edit page" do
      site = Site.factory.save
      visit "/sites/#{site.id}/edit"
      assert_have_selector 'form textarea[name="site[match_text]"]'
      assert_contain "feeling lucky"
    end

    scenario "A user updates a site record" do
      site = Site.factory.save
      visit "/sites/#{site.id}/edit"
      fill_in "email", :with => "newuser@example.com"
      click_button "save"

      assert_have_no_selector "form"
      assert_contain "newuser@example.com"
      assert_contain "feeling lucky"
    end

    scenario "A user updates a site record with invalid data" do
      site = Site.factory.save
      visit "/sites/#{site.id}/edit"
      fill_in "email", :with => "xxxxx"
      click_button "save"

      assert_not_contain "xxxxx"
      assert_have_selector "form"
    end
  end

  story "monit should be able update the satus of a site" do
    scenario "monit hits the API endpoint with a success status" do
      site = Site.factory.save

      visit "/sites/#{site.id}/status", :post, {:status => "success"}

      site = Site[site.id]
      assert_equal site.status_record.sort(:order => "DESC", :limit => 1).first, "success"
    end

    scenario "monit hits the API endpoint with a fail status" do
      site = Site.factory.save

      visit "/sites/#{site.id}/status", :post, {:status => "fail"}

      site = Site[site.id]
      assert_equal site.status_record.sort(:order => "DESC", :limit => 1).first, "fail"
    end
  end

  teardown do
    FileUtils.rm_f(Dir["monitrc/#{RACK_ENV}/*.monitrc"])
  end
end
