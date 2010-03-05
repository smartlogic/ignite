Factory.define(:event) do |e|
  e.association :ignite
  e.sequence(:name) {|i| "Event #{i}"}
  e.date { Date.today + 30 }
end