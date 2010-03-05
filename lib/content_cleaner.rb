require 'sanitize'
class ContentCleaner
  
  def self.clean(html, conf='relax')
    if conf == 'relax'
      Sanitize.clean(html, Sanitize::Config::RELAXED)
    else
      Sanitize.clean(html)
    end
  end
  
  def self.fix_link(link)
    if(link.blank? || link.match(/^http[s]{0,1}:\/\/\w+/))
      return link
    elsif link.match(/^\w+:\/\/\w+/)
      link.sub!(/^\w+:\/\//, 'http://')
    else
      return "http://" + link
    end
  end
  
end
