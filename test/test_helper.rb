ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require "contest"
require "quietbacktrace"
require "active_support/testing/assertions"
require "mocha"
require "factory_girl"

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

  self.new_backtrace_silencer :vendor do |line|
    line.include? 'vendor'
  end

  self.backtrace_silencers << :vendor
end

