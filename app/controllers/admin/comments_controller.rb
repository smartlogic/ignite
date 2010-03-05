class Admin::CommentsController < Admin::BaseAdminController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to admin_comments_url }
      format.xml  { head :ok }
    end
  end
end
