Factory.define(:article) do |a|
  a.association :ignite
  a.sequence(:name) {|i| "Article #{i}"}
end