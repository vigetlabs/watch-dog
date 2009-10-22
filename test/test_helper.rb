ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require "contest"
require "quietbacktrace"
require 'active_support/testing/assertions'
require 'mocha'

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
      @default_options = Options.new.instance_eval(&block)
    else
      options = (@default_options || {}).merge(options)
      options.each {|k,v| options[k] = v.call if v.is_a?(Proc) }
      self.new(options)
    end
  end
end

require "factories"
