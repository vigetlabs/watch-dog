require "stories_helper"

class SitesTest < Test::Unit::TestCase
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
end
