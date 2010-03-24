# load in the SLS recipes first!
gem 'capistrano-extensions', '= 0.1.8'
gem 'passenger-recipes', '>= 0.1.2'
set(:deployable_environments, [:staging, :production]) # Define our deployable environments
set(:config_structure, :sls)
require 'passenger-recipes/passenger'

set :application, "ignite"
set :scm, "git"
set :repository,  "git://github.com/smartlogic/ignite.git"
set :branch, 'production'
set(:deploy_to) { "/var/vhosts/ignite" }
set :user, "deploy"

set :shared_content, {
  "content/event"     => "public/event",
  "content/organizer" => "public/organizer",
  "content/speaker"   => "public/speaker",
  "content/ignite"    => "public/ignite",
  "content/sponsor"   => "public/sponsor"
}

set :copy_exclude, ["Capfile", "doc", "test", "tmp"]

depend(:remote, :gemfile, "config/geminstaller.yml")  # ensure that all of our gems are installed

production do
  set :ip, "208.78.102.176"
  after "deploy:symlink", :move_in_database_yml
end

staging do
  set :ip, "12.167.155.8"
end

desc "Move in database.yml for this environment"
task :move_in_database_yml, :roles => :app do
  run "cp #{deploy_to}/shared/system/database.yml #{current_path}/config/production/database.yml"
end

role :web, "#{ip}"
role :app, "#{ip}"
role :db, "#{ip}", :primary => true
