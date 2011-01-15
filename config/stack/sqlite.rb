package :sqlite, :provides => :database do
  description 'SQLite 3 Database'
  apt 'sqlite3'
  
  verify do
    has_executable 'sqlite3'
  end
  
  requires :build_essential
  optional :sqlite_driver
end
 
package :sqlite_driver, :provides => :ruby_database_driver do
  description 'Ruby SQLite database driver'
  apt 'libsqlite3-dev'
  gem 'sqlite3-ruby'
  
  verify do
    has_gem 'sqlite3-ruby'
  end
  
  requires :ruby_enterprise
end