module ApplicationHelper
  
  def pp_date(date)
    date.strftime("%B %e, %Y")
  end
  
  def link_to_event(event=nil)
    unless event.nil?
      link_to h(event.name), event_path(event), :class => "tag"
    else
      link_to "Ignite Home", root_path, :class => "tag"
    end
  end
  
  def ellipse_cutoff(string, limit=25)
    return "" if string.nil?
    if string.length > limit
      string[0,limit] + '...'
    else
      string
    end
  end
  
  def yes_or_no(bool)
    bool ? "Yes" : "No"
  end
  
end
