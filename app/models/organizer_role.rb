class OrganizerRole < ActiveRecord::Base
  has_many :organizers
  
  before_destroy :reassign_organizers
  
  validates_presence_of :title
  
  private
    def reassign_organizers
      if (Organizer.count - 1) == 0
        return false
      end
      role = OrganizerRole.find(:first, :conditions => ["id != ?", self.id])
      organizers.each do |o|
        o.update_attribute(:organizer_role_id, role.id)
      end
    end
end
