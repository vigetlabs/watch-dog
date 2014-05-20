RAKE_ENV = ENV['RAKE_ENV'] || 'development'

require 'rspec/core/rake_task'

desc 'Default task: run all specs'
task :default => [:spec]

RSpec::Core::RakeTask.new(:spec)

task :environment do
  $:.push(File.dirname(__FILE__))
  require 'init'

  ActiveRecord::Base.logger = Logger.new('log/database.log')
  RAILS_ROOT = File.dirname(__FILE__)
end

Dir['tasks/**/*.rake'].each do |rakefile|
  load rakefile
end
