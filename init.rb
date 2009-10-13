ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require 'active_support'
require 'mustache/sinatra'
require 'ohm'

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
  register Mustache::Sinatra
  set :views, root_path('app', 'templates')
  set :mustaches, root_path('app', 'views')
  
  configure do
    Ohm.connect
    # Load all application files.
    Dir[root_path("app/**/*.rb")].each do |file|
      require file
    end
  end  
end

Main.run! if Main.run?
