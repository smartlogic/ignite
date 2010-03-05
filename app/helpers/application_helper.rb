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
    ret = ""
    if string.length > limit
      ret = string[0,limit-3] + '...'
    else
      ret = string
    end
    return escape_javascript(ret)
  end
  
  def more_link(string, link, limit=25)
    ret = ""
    if string.length > limit
      ret = string[0,limit-3] + link_to("... Read more", link)
    else
      ret = string
    end
    return escape_javascript(ret)
  end
  
  def insert_article_text(text, prepend="", append="")
    ret = ""
    ret = prepend << text << append
    return ret
  end
  
end
