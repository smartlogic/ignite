class AddIgniteIdToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :ignite_id, :integer
    add_index :admins, :ignite_id
    add_foreign_key :admins, :ignite_id, :ignites, :id
    
    run("update admins set ignite_id = 1 where id in (1,3,4,9,12)")
    run("update admins set ignite_id = 2 where id in (6,7,8,13,16)")
    run("update admins set ignite_id = 3 where id in (10,11)")
    run("update admins set ignite_id = 4 where id in (15)")
  end

  def self.down
    # eh
  end
  
  def self.run(sql)
    connection.execute(sql)
  end
end
