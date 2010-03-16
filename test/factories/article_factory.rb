Factory.define(:attrs_for_article, :default_strategy => :attributes_for, :class => 'Article') do |a|
  a.sequence(:name) {|i| "Article #{i}"}
end

Factory.define(:article, :parent => :attrs_for_article) do |a|
  a.after_build {|a| a.ignite || Factory(:ignite) }
end
