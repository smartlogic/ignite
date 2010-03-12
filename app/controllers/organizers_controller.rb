class OrganizersController < BaseUserController

  def index
    @page_title = "Organizers"
    @organizers = @ignite.organizers
  end

  def show
    @organizer = @ignite.organizers.find(params[:id])
    @page_title = "#{@organizer.name} | Organizers"
  end

end
