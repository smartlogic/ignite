Given /^"([^\"]*)" is receiving email notifications$/ do |email|
  @current_ignite.update_attributes!(:emails => email)
end
