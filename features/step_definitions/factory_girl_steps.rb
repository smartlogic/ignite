Given /^Ignite (.*) exists$/ do |city|
  ignite = Factory(:ignite, :city => city)
  header "host", ignite.domain + ".com"
end
