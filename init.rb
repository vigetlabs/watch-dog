ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies-0.0.7/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require 'active_support'
require 'active_record'
require 'mustache/sinatra'

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
  register Mustache::Sinatra
  set :views, root_path('app', 'templates')
  set :mustaches, root_path('app', 'views')

  configure do
    # Set up ActiveRecord
    @db_config = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.configurations = @db_config
    ActiveRecord::Base.establish_connection(@db_config[Main.environment.to_s])

    # Load all application files.
    Dir[root_path("app/**/*.rb")].each do |file|
      require file
    end
  end
end

Main.run! if Main.run?
