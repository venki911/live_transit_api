set :application, "live_transit_api"
set :repository,  "git@github.com:ipublic/live_transit_api.git"
set :deploy_to, "/var/www/live_transit_api"

set :scm, :git
set :use_sudo, false
set :deploy_via, :copy
set :user, :root
set :keep_releases, 2

set :db_connection_settings_file, File.join(File.dirname(__FILE__), "couchdb.yml")

ssh_options[:keys] = [
  File.join(
    ENV["HOME"],
    "proj",
    "ec2_keypairs",
    "rideon",
    "ride-ontime.com",
    "ride-ontime.com.pem"
  )
]

role :web, "107.20.248.237"
role :app, "107.20.248.237"
role :db, "107.20.248.237", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
     put(File.read(db_connection_settings_file), "#{File.join(current_path, 'config', 'couchdb.yml')}", :via => :scp)
     run "rvm rvmrc trust #{File.join(current_release)}"
     run "chown apache:apache #{File.join(current_path,'..','..')} -R"
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end