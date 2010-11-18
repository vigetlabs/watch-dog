require "test_helper"

require "webrat"
require "rack/test"
require "stories"
require "stories/runner"

Webrat.configure do |config|
  config.mode = :sinatra
end

class Test::Unit::TestCase
  include Webrat::Methods
  include Webrat::Matchers
  include Stories::Webrat
end
