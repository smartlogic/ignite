When /^I submit a proposal "([^\"]*)"$/ do |title|
  visit new_proposal_path
  fill_in "Name", :with => "Joe"
  fill_in "Email", :with => "joe@localhost"
  fill_in "Website", :with => "http://localhost"
  fill_in "Proposal Title", :with => title
  fill_in "Description", :with => "Something rad"
  fill_in "Brief Bio", :with => "Something else rad"
  click_button "Submit your 5-min topic"
  follow_redirect!
end
