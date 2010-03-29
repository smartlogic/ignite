Then /^"([^\"]*)" receives a notification email$/ do |email|
  assert_sent_email do |_email|
    _email.subject =~ /submitted proposal/ &&
      _email.to.include?(email)
  end
end

Then /^no one receives a notification email$/ do
  assert !::ActionMailer::Base.deliveries.any? {|_email|
    _email.subject =~ /submitted proposal/
  }
end

Then /^the submitter receives a thank you email$/ do
  assert_sent_email do |_email|
    _email.subject =~ /Thank you for submitting your proposal/ &&
      _email.to.include?(@last_submitted_proposal.email)
  end
end
