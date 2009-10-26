set :application, "watch-dog"
set :use_sudo, false
set :repository,  "git://github.com/vigetlabs/watch-dog.git"
set :scm, :git

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

set(:moinitrc_path) { File.join(shared_path, 'monitrc') }

set :deploy_to, "/var/www/html/#{application}"

set :user, "watch-dog-deploy"

role :web, "your.server.com"
role :app, "your.server.com"
role :db,  "your.server.com", :primary => true

set :branch, 'origin/master'

after  "deploy:update_code",  "app:symlinks"

namespace :deploy do
  desc "Deploy"
  task :default do
    update
    restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    dirs += [File.join(moinitrc_path, 'development'), File.join(moinitrc_path, 'test'), File.join(moinitrc_path, 'production')]
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Restart the application"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path}; touch tmp/restart.txt"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

namespace :app do
  desc "Make symlinks"
  task :symlinks do
    run "ln -nfs #{shared_path}/monitrc #{current_path}/monitrc"
  end
end
