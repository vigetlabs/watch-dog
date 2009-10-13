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
end
