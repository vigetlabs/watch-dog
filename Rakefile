RAKE_ENV = ENV['RAKE_ENV'] || 'development'

desc 'Default task: run all tests'
task :default => [:test]

task :test do
  exec "thor monk:test"
end

task :environment do
  $:.push(File.dirname(__FILE__))
  require 'init'

  ActiveRecord::Base.logger = Logger.new('log/database.log')
  RAILS_ROOT = File.dirname(__FILE__)
end

Dir['tasks/**/*.rake'].each do |rakefile|
  load rakefile
end