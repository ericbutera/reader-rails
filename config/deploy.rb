set :application, "reader-rails"
set :repository,  "git@github.com:ericbutera/reader-rails.git"

default_run_options[:pty] = true 

set :scm, :git
set :user, "deployer"
set :use_sudo, false
set :deploy_to, "/home/deployer/code/#{application}"
# set :deploy_via, :remote_cache
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "irontusk.net"                          # Your HTTP server, Apache/etc
role :app, "irontusk.net"                          # This may be the same as your `Web` server
role :db,  "irontusk.net", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# set :whenever_command, "whenever"
# require "whenever/capistrano"

after "deploy", "deploy:copy_database"
after "deploy:copy_database", "deploy:restart"

namespace :deploy do
  task :copy_database do
    run "ln -s #{deploy_to}/database.yml #{release_path}/config/database.yml"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

