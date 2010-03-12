module Admin::AdminsHelper
  def can_edit?(admin)
    current_admin.superadmin? || !admin.superadmin?
  end
  
  def can_remove?(admin)
    (current_admin.superadmin? || !admin.superadmin?) && current_admin != admin
  end
end