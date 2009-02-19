DEPLOY_CONFIG = YAML.load_file("config/configuration.yml")['deploy']

set :application, "f1.ruby.mn"
set :scm, :git
set :branch, "master"
set :repository,  "git@github.com:#{DEPLOY_CONFIG['owner']}/f1-2009.git"
set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache
 
set :user, DEPLOY_CONFIG['user']
set :password, DEPLOY_CONFIG['password']
set :ssh_options, { :forward_agent => true, :port => DEPLOY_CONFIG['port'], :paranoid => false }
default_run_options[:pty] = true # required for svn+ssh:// and git:// sometimes 
 
role :app, "f1.ruby.mn"
role :web, "f1.ruby.mn"
role :db,  "f1.ruby.mn", :primary => true
 
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

