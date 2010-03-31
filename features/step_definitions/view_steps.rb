When /^I visit the proposals page$/ do
  visit proposals_speakers_path
end

When /^I view the proposal$/ do
  visit speaker_path(@last_submitted_proposal)
end