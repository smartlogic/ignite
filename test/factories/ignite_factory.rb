Factory.define(:ignite) do |i|
  i.sequence(:city) {|num| "City #{num}"}
  i.sequence(:domain) {|num| "ignite#{num}.localhost"}
  i.proposals_closed false
  
end