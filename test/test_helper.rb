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

module Factory
  class Options
    def method_missing(method, *args)
      @records ||= {}
      @records[method] = args.first
      @records
    end
  end

  def factory(options = {}, &block)
    if block_given?
      @default_options = Options.new.instance_eval(&block)
    else
      self.new((@default_options || {}).merge(options))
    end
  end
end

Ohm::Model.extend(Factory)

require "factories"
