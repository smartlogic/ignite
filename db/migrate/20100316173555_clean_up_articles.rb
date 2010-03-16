class CleanUpArticles < ActiveRecord::Migration
  def self.up
    run "DELETE FROM articles WHERE name = 'Proposal Submitted'"
    run "DELETE FROM articles WHERE name = 'PastEventsDescription'"
    run "DELETE FROM articles WHERE name = 'OrganizerIndexDescription'"
    
    add_column :articles, :show_in_navigation, :boolean, :default => false
    run "UPDATE articles SET show_in_navigation = 1, name = 'About Ignite' WHERE name = 'About'"
    run "UPDATE articles SET show_in_navigation = 1 WHERE name = 'Sponsor Ignite'"
    run "UPDATE articles SET show_in_navigation = 1, name = 'Friends' WHERE name = 'Affiliates'"
  end

  def self.down
  end
  
  def self.run sql
    connection.execute(sql)
  end
end
