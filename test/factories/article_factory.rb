Factory.define(:article) do |a|
  a.sequence(:name) {|i| "Article #{i}"}
  a.association :ignite
end
