class ChangeMeaningOfProposal < ActiveRecord::Migration
  def self.up
    # Set state to 'proposal' for all active speakers
    run "UPDATE speakers SET aasm_state = 'proposal' WHERE aasm_state = 'active'"
    # Set state to selected for all "speakers"
    run "UPDATE speakers SET aasm_state = 'speaker' WHERE event_id IS NOT NULL"

    # Assign each proposal to an ignite based on date
    # Baltimore
    run "UPDATE speakers SET event_id = 3 WHERE event_id IS NULL AND id < 139 AND ignite_id = 1"
    run "UPDATE speakers SET event_id = 6 WHERE event_id IS NULL AND id < 281 AND ignite_id = 1"
    run "UPDATE speakers SET event_id = 10 WHERE event_id IS NULL AND ignite_id = 1"
    
    # DC
    run "UPDATE speakers SET event_id = 4 WHERE event_id IS NULL AND id < 131 AND ignite_id = 2"
    run "UPDATE speakers SET event_id = 7 WHERE event_id IS NULL AND id < 252 AND ignite_id = 2"
    run "UPDATE speakers SET event_id = 11 WHERE event_id IS NULL AND ignite_id = 2"
    
    # Annapolis
    run "UPDATE speakers SET event_id = 5 WHERE event_id IS NULL AND ignite_id = 3"
    
    # RailsConf
    run "UPDATE speakers SET event_id = 8 WHERE event_id IS NULL AND ignite_id = 4"
    
    remove_column :speakers, :ignite_id
  end

  def self.down
    # eh
  end
  
  def self.run sql
    connection.execute(sql)
  end
end
