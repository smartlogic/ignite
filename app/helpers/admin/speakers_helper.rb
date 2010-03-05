module Admin::SpeakersHelper
  
  def optgroup_settings_dropdown(title, links=[])
    "<div class='select_segment'><h3>#{title}</h3>" +
      select_tag("select", grouped_options_for_select(links), :onchange => "document.location = this.value") +
      "</div>"
  end

  def grouped_options_for_select(grouped_options, selected_key = nil, prompt = nil)
    body = ''
    body << content_tag(:option, "Select", :value => "")

    grouped_options = grouped_options.sort if grouped_options.is_a?(Hash)

    grouped_options.each do |group|
      body << content_tag(:optgroup, options_for_select(group[1], selected_key), {:label => group[0]}, false)
    end

    body
  end
  
end
