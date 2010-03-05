# Defines a basic cached accessor
def meta_accessor(accessor, klass, find_by_field="name", field_value=accessor)
  src = <<-RUBY
    def #{accessor}(reload=false)
      return @#{accessor} if @#{accessor} && !reload
      @#{accessor} = #{klass.to_s}.find_by_#{find_by_field}("#{field_value}")
    end
  RUBY
  class_eval src, __FILE__, __LINE__
end

# Generalized accessor functor
def scoped_meta_accessor(model_str, key, value, scoped_type, scoped_type_id, default_accessor_str)
  scoped_field = "#{scoped_type}_id"
  src = <<-RUBY
    def #{key}(#{scoped_type}=#{default_accessor_str}, reload=false)
      key = "@#{key}_" + #{scoped_type}.#{scoped_type_id}.to_s.gsub(' ', '_')
      if reload || !instance_variable_defined?(key.to_sym)
        instance_variable_set(key.to_sym, #{model_str}.find_by_name_and_#{scoped_field}(%q(#{value}), #{scoped_type}.id))
      end
      instance_variable_get(key.to_sym)
    end
  RUBY
  class_eval src, __FILE__, __LINE__
end

module StoryAccessors
  
  module Methods

    ####### Admins #######
     %w(pattichan subelsky ggentzke).each do |acct|
       meta_accessor(acct.to_s, Admin, "login")
     end
     
    ####### Ignites #######
    %w(baltimore dc).each do |city|
      meta_accessor(city.to_s, Ignite, "city")
    end
    
    ####### Org'r Roles #######
    meta_accessor("founder", OrganizerRole, "title", "Founder")
    meta_accessor("guest_organizer", OrganizerRole, "title", "Guest Organizer")
    
    ####### Founders #######
    meta_accessor('mike', Organizer, "name", "Mike Subelsky")
    meta_accessor('patti', Organizer, "name", "Patti Chan")
    
    ####### Org'rs #######
    meta_accessor('david', Organizer, "name", "David Adewumi")
    meta_accessor('brent', Organizer, "name", "Brent Halliburton")
    
    ####### Events #######
    meta_accessor('ignite1', Event, "name", "Ignite no. 1")
    meta_accessor('ignite2', Event, "name", "Ignite no. 2")
    
    ####### Speakers #######
    meta_accessor('brian', Speaker, "name", "Brian Le Gette")
    meta_accessor('bruce', Speaker, "name", "Bruce Yang")
    meta_accessor('chris', Speaker, "name", "Chris Hopkinson")
    
    ####### Proposals #######
    meta_accessor('proposal', Speaker, "name", "Pro McPosal")
    
    ####### Articles #######
    meta_accessor('news_article', Article, 'name', 'How to get into Ignite #2')
    meta_accessor('news_article_no_comments', Article, 'comments_allowed', false)
    meta_accessor('regular_article', Article, 'name', 'About')
    meta_accessor('submission_article', Article, 'name', "Proposal Submitted")
    
    ####### Comments #######
    meta_accessor('news_comment', Comment, 'author', 'glenn')
    meta_accessor('speaker_comment', Comment, 'author', 'bob')
    
  end
  
end
