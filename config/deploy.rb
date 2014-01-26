set :application, 'gimson_robotics'
set :user, 'root'
set :scm, 'git'
set :repository, 'git@github.com:Jellyfishboy/gimson_robotics.git'
set :scm_verbose, true
set :domain, '146.185.130.90'
set :deploy_to, '/var/www/gimsonrobotics/'
set :branch, 'master'

server domain, :app, :web, :db, :primary => true

require 'capistrano-unicorn'

# Bundler for remote gem installs
require "bundler/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

set :normalize_asset_timestamps, false

# deploy config
set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
set :use_sudo, false

namespace :configure do
  desc "Setup carrierwave configuration"
  task :carrierwave, :roles => :app do
      run "yes | cp /var/www/configs/carrierwave_config.rb /var/www/gimsonrobotics/current/config/initializers"
  end
  desc "Setup asset_sync configuration"
  task :asset_sync, :roles => :app do
      run "yes | cp /var/www/configs/asset_sync.rb /var/www/gimsonrobotics/current/config/initializers"
  end
  desc "Setup PayPal configuration"
  task :paypal, :roles => :app do
      run "yes | cp /var/www/configs/production.rb /var/www/gimsonrobotics/current/config/environments"
  end
  desc "Setup database configuration"
  task :database, :roles => :app do
    run "yes | cp /var/www/configs/database.yml /var/www/gimsonrobotics/current/config"
  end
end
namespace :assets do
    desc "Compile assets"
    task :compile, :roles => :app do
        run "cd /var/www/gimsonrobotics/current && bundle exec rake assets:precompile"
    end
    desc "Generate sitemap"
    task :refresh_sitemaps do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
    end
end
namespace :rollbar do
  desc "Notify Rollbar of deployment"
  task :notify_rollbar, :roles => :app do
    set :revision, `git log -n 1 --pretty=format:"%H"`
    set :local_user, `whoami`
    set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
    rails_env = fetch(:rails_env, 'production')
    run "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{rollbar_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1", :once => true
  end
end

# additional settings
default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'

after :deploy, :configure
after :configure, :assets
after :assets, :rollbar
after :rollbar, 'unicorn:restart' 
