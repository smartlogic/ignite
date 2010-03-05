module BaseUserHelper
  #12 W. North Ave., Baltimore, MD 21201
  def pp_event_location(evt)
    "#{evt.address_line1} #{(evt.address_line2 + " ") unless evt.address_line2.blank?}, #{evt.city}, #{evt.state} #{evt.zip}"
  end
  
end
