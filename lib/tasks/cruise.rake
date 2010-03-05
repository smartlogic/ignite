# Add cruise task to bottom after 'requires': 
desc "Runs cruise control build."
task :cruise => ["cruise:rails"]

namespace :cruise do
    
  desc <<-DESC
    Run your standard rails test:all test suite.  Should be invoked in isolation, as the environment cannot be changed after
    this task runs.  Likewise, if a different task previously loaded one environment, this task would no be able to change it.
  DESC
  task :rails => ['cruise:rails:prepare', 'test:all']

  namespace :rails do
    desc <<-DESC
      db:drop db:create db:schema:load db:stories
    DESC
    task :prepare => [:environment, 'db:drop', 'db:create', 'db:schema:load', 'db:stories']
  end

end