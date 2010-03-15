class Admin::ArticlesController < Admin::BaseAdminController
  before_filter :load_article, :only => [:show, :edit, :update, :destroy]
  
  def index
    @articles = @ignite.articles.find(:all, :order => "created_at DESC")
  end

  def show
    
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    @article.ignite = @ignite

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to([:admin, @article]) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to([:admin, @article]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article.destroy
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "#{@article.name} has been removed."
        redirect_to(admin_articles_url) 
      }
      format.xml  { head :ok }
    end
  end
  
  private
    def load_article
      @article = @ignite.articles.find(params[:id])
    end
end
