ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require "contest"
require "quietbacktrace"
require 'active_support/test_case'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include ActiveSupport::Testing::SetupAndTeardown
  include ActiveSupport::Testing::Assertions

  def app
    Main.new
  end
end
