Given /^Ignite "([^\"]*)"$/ do |city|
  @current_ignite ||= Factory(:ignite, :city => city, :emails => "john@localhost")
  header "host", @current_ignite.domain + ".com"
end

Given /^Ignite "([^\"]*)" without notification emails$/ do |city|
  @current_ignite ||= Factory(:ignite, :city => city)
  header "host", @current_ignite.domain + ".com"
end

Given /^a proposal exists for the featured event$/ do
  @last_submitted_proposal = Factory(:proposal, :event => @current_ignite.featured_event)
end

Given /^a proposal "([^\"]*)" exists for the featured event$/ do |title|
  @last_submitted_proposal = Factory(:proposal, :event => @current_ignite.featured_event, :title => title)
end

Given /^the featured event is no longer accepting proposals$/ do
  @current_ignite.featured_event.update_attributes!(:accepting_proposals => false)
end
