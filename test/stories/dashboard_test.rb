require "stories_helper"

class DashboardTest < Test::Unit::TestCase
  story "I should be able to visit the home page which is a dashboard" do
    scenario "A visitor goes to the homepage" do
      visit "/"

      assert_contain "Watch Dog"
      assert_contain "Add Site to Watch"
    end
  end
end
