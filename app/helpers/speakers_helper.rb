module SpeakersHelper
  
  def widget_image(speaker, image, suffix)
    if speaker.attribute_present?(image)
      return url_for_file_column(speaker, image)
    else
      return "/images/speakers/blank_#{suffix}.jpg"
    end
  end
  
end
