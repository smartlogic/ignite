Factory.define(:superadmin, :class => 'Admin') do |a|
  a.sequence(:login) {|i| "admin#{i}"}
  a.sequence(:password) {|i| "admin#{i}"}
  a.sequence(:password_confirmation) {|i| "admin#{i}"}
  a.sequence(:email) {|i| "admin#{i}@slsdev.net"}
end

Factory.define(:admin, :parent => :superadmin) do |a|
  a.association :ignite
end