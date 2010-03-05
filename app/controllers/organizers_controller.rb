class OrganizersController < BaseUserController

  def index
    @page_title = "Organizers"
    rid = OrganizerRole.find_by_title('founder').id
    @founders = @ignite.organizers.find(:all, :conditions => {:organizer_role_id => rid}, :order => :name)
    @fanchors = {}
    @founders.each do |f|
      @fanchors[f.name.downcase.gsub(/\s/,'_')] = f
    end
    gid = OrganizerRole.find_by_title('guest organizer').id
    @guests = @ignite.organizers.find(:all, :conditions => {:organizer_role_id => gid}, :order => :name)
    @ganchors = {}
    @guests.each do |g|
      @ganchors[g.name.downcase.gsub(/\s/,'_')] = g
    end
    oid = @ignite.articles.find_by_name("OrganizerIndexDescription")
    @organizer_index_description = oid ? oid.html_text : "<h3>Create an article named \"OrganizerIndexDescription\" to replace this text.</h3>"
  end

  def show
    @organizer = @ignite.organizers.find(params[:id])
    @page_title = "#{@organizer.name} | Organizers"
  end

end
