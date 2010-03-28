Given /^Ignite "([^\"]*)"$/ do |city|
  @current_ignite ||= Factory(:ignite, :city => city)
  header "host", @current_ignite.domain + ".com"
end

When /^I visit the proposals page$/ do
  visit proposals_speakers_path
end
