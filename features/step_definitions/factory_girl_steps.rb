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
