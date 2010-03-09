Factory.define(:organizer) do |o|
  o.association :ignite
  o.sequence(:name) {|i| "Organizer#{i}"}
end