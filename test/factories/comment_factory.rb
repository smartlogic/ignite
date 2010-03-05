Factory.define(:comment) do |c|
  c.association :proposal
  c.author "A commenter"
  c.email "anemail@slsdev.net"
  c.url "http://mysite.com"
  c.content "An insightful comment"
end