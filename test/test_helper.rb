ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require "contest"
require "quietbacktrace"
require 'active_support/testing/assertions'

Ohm.flush

Debugger.start
Debugger.settings[:autoeval] = true
Debugger.settings[:autolist] = 1

class Test::Unit::TestCase
  include Rack::Test::Methods
  include ActiveSupport::Testing::Assertions

  def app
    Main.new
  end
  
  def assert_contains(collection, x, extra_msg = "")
    collection = [collection] unless collection.is_a?(Array)
    msg = "#{x.inspect} not found in #{collection.to_a.inspect} #{extra_msg}"
    case x
    when Regexp
      assert(collection.detect { |e| e =~ x }, msg)
    else         
      assert(collection.include?(x), msg)
    end
  end
  
  def assert_does_not_contain(collection, x, extra_msg = "")
    collection = [collection] unless collection.is_a?(Array)
    msg = "#{x.inspect} found in #{collection.to_a.inspect} " + extra_msg
    case x
    when Regexp
      assert(!collection.detect { |e| e =~ x }, msg)
    else         
      assert(!collection.include?(x), msg)
    end
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
      @default_options = block
    else
      @default_options.nil? ?
        self.new(options) :
        self.new(@default_options.call.merge(options))
    end
  end
end

Ohm::Model.extend(Factory)

require "factories"
