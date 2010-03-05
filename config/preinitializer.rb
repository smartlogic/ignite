# Ensure that proper versions of gems in config/geminstaller.yml are activated.
require 'rubygems'
gem 'rails', '= 2.2.2'
gem 'geminstaller', '= 0.5.1'
require 'geminstaller'

rails_env = ENV['RAILS_ENV'] || 'development'

perform_install = false #%w(test).include?(rails_env)

# Activate gems
common_gemfile = File.join(RAILS_ROOT, 'config', 'geminstaller.yml')
Gem.refresh
env_gemfile    = File.join(RAILS_ROOT, "config", rails_env, "geminstaller.yml")

[common_gemfile, env_gemfile].each do |file|
  if File.exists?(file)
    GemInstaller.install("--exceptions --config=#{file}") if perform_install
    Gem.refresh
    GemInstaller.autogem("--exceptions --config=#{file}")
  end
end
