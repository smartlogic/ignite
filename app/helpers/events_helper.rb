module EventsHelper
  
  def pp_location(event)
    ret = event.date.strftime("%B %e, %Y, %l%P - ??")
    ret += "<br/>"
    ret += h(event.location_name) + "<br/>"
    ret += h(event.address_line1) + "<br/>"
    ret += h(event.address_line2) + "<br/>" unless event.address_line2.blank?
    ret += "#{h(event.city)}, #{h(event.state)} #{h(event.zip)}<br/>"
    return ret
  end
  
  def speaker_list_item(spk)
    ret = link_to(h(spk.name), speaker_url(spk))
    ret += link_to(" - <strong>view video</strong>", spk.video_url) unless spk.video_url.blank?
    ret += "&nbsp;" + h(spk.title)
    return ret
  end
  
end
