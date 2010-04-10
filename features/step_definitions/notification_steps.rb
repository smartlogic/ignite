Then /^Ignite "([^\"]*)" admins receive a proposal notification email$/ do |city|
  ignite = Ignite.find_by_city(city)
  assert_sent_email do |_email|
    _email.subject =~ /submitted proposal/ &&
      ignite.emails_as_array.all? {|email| _email.to.include?(email) }
  end
end

Then /^no one receives a proposal notification email$/ do
  assert !::ActionMailer::Base.deliveries.any? {|_email|
    _email.subject =~ /submitted proposal/
  }
end

Then /^the submitter receives a thank you email$/ do
  assert_sent_email do |_email|
    _email.subject =~ /Thank you for submitting your proposal/ &&
      _email.to.include?(@last_submitted_proposal.email) &&
      _email.body.include?(@last_submitted_proposal.key)
  end
end

Then /^Ignite "([^\"]*)" admins receive a comment notification email$/ do |city|
  ignite = Ignite.find_by_city(city)
  assert_sent_email do |_email|
    _email.subject =~ /Someone commented on a proposal/ &&
      ignite.emails_as_array.all? {|email| _email.to.include?(email) }
  end
end

Then /^the submitter receives a comment notification email$/ do
  assert_sent_email do |_email|
    _email.subject =~ /A comment was left on your proposal/ &&
      _email.to.include?(@last_submitted_proposal.email)
  end
end

