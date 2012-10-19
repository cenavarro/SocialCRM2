require 'capistrano/ext/multistage'

set :application, "social_crm"
set :scm, :git
set :repository,  "https://cenavarro@github.com/cenavarro/SocialCRM2.git"
server "184.106.134.102", :app, :web, :db, :primary => true
set :scm_username, "cenavarro"
set :user, "deployer"
set :default_stage, "production"
default_run_options[:pty] = true

set :scm_passphrase, "Pernix-D3ploy3R"
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "master"
set :deploy_via, :remote_cache

set :stages, ["production"]

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
