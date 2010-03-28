When /^(a visitor|I) submits? a proposal$/ do |article|
  When %Q[a visitor submits a proposal "Proposal Title"]
end

When /^(a visitor|I) submits? a proposal "([^\"]*)"$/ do |article, title|
  visit new_proposal_path
  fill_in "Name", :with => "Joe"
  fill_in "Email", :with => "joe@localhost"
  fill_in "Website", :with => "http://localhost"
  fill_in "Proposal Title", :with => title
  fill_in "Description", :with => "Something rad"
  fill_in "Brief Bio", :with => "Something else rad"
  click_button "Submit your 5-min topic"

  @last_submitted_proposal = @current_ignite.speakers.proposal.last
  assert_redirected_to speaker_path(@last_submitted_proposal)
  follow_redirect!
end

When /^I submit an incomplete proposal "([^\"]*)"$/ do |article|
  visit new_proposal_path
  fill_in "Name", :with => "Joe"
  click_button "Submit your 5-min topic"
  assert_response :success
  assert_template 'new'
end
