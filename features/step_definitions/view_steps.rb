When /^I visit the proposals page$/ do
  visit proposals_speakers_path
end

When /^I view the proposal$/ do
  visit speaker_path(@last_submitted_proposal)
end

When /^I view the edit proposal page with its edit key$/ do
  visit edit_proposal_path(@last_submitted_proposal, :key => @last_submitted_proposal.key)
end

When /^I view the edit proposal page$/ do
  visit edit_proposal_path(@last_submitted_proposal)
end

Then /^I should be redirected$/ do
  assert_response :redirect
end

When /^I follow the redirect$/ do
  follow_redirect!
end