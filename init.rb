ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies-0.0.9/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require 'sass'
require 'active_support'
require 'active_record'
require 'mustache/sinatra'

log = File.new("log/sinatra.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
  if RACK_ENV.to_sym == :production
    use Rack::Auth::Basic do |username, password|
      username == monk_settings(:http_auth_username) && password == monk_settings(:http_auth_password)
    end
  end
  register Mustache::Sinatra
  set :views, root_path('app', 'templates')
  set :mustache, {
    :templates => root_path('app', 'templates'),
    :views => root_path('app', 'views')
  }
  set :raise_errors, true
  set :show_exceptions

  configure do
    # Set up ActiveRecord
    @db_config = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.configurations = @db_config
    ActiveRecord::Base.establish_connection(@db_config[Main.environment.to_s])

    # Load all application files.
    Dir[root_path("app/helpers/**/*.rb")].each do |file|
      require file
    end
    Dir[root_path("app/**/*.rb")].each do |file|
      require file
    end
  end
end

Main.run! if Main.run?
