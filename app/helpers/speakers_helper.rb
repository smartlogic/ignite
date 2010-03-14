module SpeakersHelper
  
  def widget_image(speaker, image, suffix)
    if speaker.attribute_present?(image)
      return url_for_file_column(speaker, image)
    else
      return "/images/speakers/blank_#{suffix}.jpg"
    end
  end

  def more_link(string, link, limit=25)
    ellipse_cutoff(string, limit) + link_to("Read more", link)
  end
  
  def speaker_links(speaker)
    links = {}
    ['company_url', 'personal_url', 'blog_url', 'twitter_url', 'linkedin_url'].each do |link|
      unless speaker.send(link).blank?
        label = link.match(/^(\w+)_url/)[1].capitalize
        links[label] = speaker.send(link)
      end
    end
    links
  end
end
