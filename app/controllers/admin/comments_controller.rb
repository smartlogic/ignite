class Admin::CommentsController < Admin::BaseAdminController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = @ignite.article_comments.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @ignite.article_comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { 
        flash[:notice] = "Comment removed."
        redirect_to admin_comments_url 
      }
      format.xml  { head :ok }
    end
  end
end
