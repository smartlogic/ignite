Factory.define(:event) do |e|
  e.association :ignite
  e.sequence(:name) {|i| "Event #{i}"}
  e.association :organizer
  e.description "The best Ignite yet"
  e.date { Date.today + 30 }
  e.is_complete false
end

Factory.define(:featured_event, :parent => :event) do |fe|
  fe.is_featured true
end

Factory.define(:past_event, :parent => :event) do |pe|
  pe.date { Date.today - 30 }
  pe.is_complete true
end