class AddEmailsToIgnites < ActiveRecord::Migration
  def self.up
    add_column :ignites, :emails, :string, :size => 512
  end

  def self.down
  end
end
