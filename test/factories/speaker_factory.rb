Factory.define(:speaker) do |s|
  s.name "A Speaker"
  s.title "Mr."
  s.description "A grand ole talk that runs many lines.  We should probably come back later and add some Textile-flavored markup because I know that I'm going to want to start supporting that for the speakers so that the descriptions don't just get all jammed together.  Lovely."
  s.bio "Again, we should probably make sure that we add Textile-flavored markup support because my bio should be able to look cool too!"

  s.ignite {
    @ignite = Factory(:ignite)
  }
  s.event { 
    Factory(:event, :ignite => @ignite)
  }
end

Factory.define(:proposal, :class => 'Speaker') do |p|
  p.name "A Speaker"
  p.title "Mr."
  p.description "A grand ole talk that runs many lines.  We should probably come back later and add some Textile-flavored markup because I know that I'm going to want to start supporting that for the speakers so that the descriptions don't just get all jammed together.  Lovely."
  p.bio "Again, we should probably make sure that we add Textile-flavored markup support because my bio should be able to look cool too!"
  p.association :ignite
end