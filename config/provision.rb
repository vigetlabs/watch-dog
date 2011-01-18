require 'highline/import'
require 'erb'

# Require our stack
Dir[File.join(File.dirname(__FILE__), 'stack', '*.rb')].each do |lib|
  require lib
end

policy :watchdog_stack, :roles => :provision do
  requires :ruby_enterprise
  requires :nginx_passenger
  requires :nginx_conf
  requires :nginx_init
  requires :git
  requires :monit
  requires :monit_conf
  requires :monit_init
  requires :rack
  requires :sinatra
  requires :sqlite
  requires :sqlite_driver
end

deployment do
  # mechanism for deployment
  delivery :capistrano do    
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end    
    
    default_run_options[:pty] = true
    set :use_sudo, true
    role :provision, ask("Enter the IP address or hostname to provision: ")
    set :user, ask("Enter your username on the host to provision: ") { |q| q.default = ENV['USER'] }    
  end
 
  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

# Depend on a specific version of sprinkle 
begin
  gem 'sprinkle', ">= 0.2.6" 
rescue Gem::LoadError
  puts "sprinkle 0.2.6 required.\n Run: `gem install sprinkle`"
  exit
end
