#!/bin/sh
set -e

echo "running cruise:rails"
rake RAILS_ENV=test cruise:rails
echo "cruise:rails_tests executed successfully"

# echo "running cruise:production_migration"
# rake RAILS_ENV=test cruise:production_migration
# echo "cruise:production_migration executed successfully"