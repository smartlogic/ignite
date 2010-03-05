class CorrectPositionTypoInSpeakers < ActiveRecord::Migration
  def self.up
    change_table :speakers do |t|
      t.rename :postion, :position
    end
  end

  def self.down
    change_table :speakers do |t|
      t.rename :position, :postion
    end
  end
end
