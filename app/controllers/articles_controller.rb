class ArticlesController < BaseUserController
  include ReCaptcha::ViewHelper
  
  def about
    @page_title = "About"
    @article = @ignite.articles.find_by_name("About")
    unless @article
      @article = Article.new(:name => "missing", :ignite => @ignite,
                             :html_text => "<h2>This article does not exist.</h2><h3>Create an article and titled it 'About' to replace this message.")
    end
    render :template => 'articles/static'
  end
  
  def friends
    @page_title = "Friends"
    @article = @ignite.articles.find_by_name("Affiliates")
    unless @article
      @article = Article.new(:name => "missing", :ignite => @ignite,
                             :html_text => "<h2>This article does not exist.</h2><h3>Create an article and titled it 'Affiliates' to replace this message.")
    end
    render :template => 'articles/static'
  end
  
  def index
    @articles = sticky_sort(@ignite.articles)
    @widget_speakers = Speaker.find(:all, :conditions => {:aasm_state => "active", :event_id => @ignite.featured_event.id}, :order => :position)
    @selected_speaker = @widget_speakers[rand(@widget_speakers.size)]
  end

  def news
    @page_title = "News"
    @articles = sticky_sort(@ignite.articles.find(:all, :conditions => {:is_news => true}, :order => "created_at DESC"))
    
    @widget_speakers = Speaker.find(:all, :conditions => {:aasm_state => "active", :event_id => @ignite.featured_event.id}, :order => :position)
    @selected_speaker = @widget_speakers[rand(@widget_speakers.size)]

    render :action => 'index'
  end
  
  def sponsor_ignite
    @page_title = "Sponsor Ignite"
    @article = @ignite.articles.find_by_name("Sponsor Ignite")
    unless @article
      @article = Article.new(:name => "missing", :ignite => @ignite,
                             :html_text => "<h2>This article does not exist.</h2><h3>Create an article and titled it 'Sponsor Ignite' to replace this message.")
    end
    render :template => 'articles/static'
  end
  
  def top_news
    @article = @ignite.articles.find(:first, :conditions => {:is_news => true}, :order => "created_at DESC")
    if params[:static]
      render :template => 'articles/static' and return
    end
    if @article
      @comments = @article.comments
      @comment = Comment.new
      @captcha = get_captcha
      render :action => 'show'
    else #There is no news to report
      redirect_to about_path
    end
  end

  def show
    @article = @ignite.articles.find(params[:id])
    if params[:static]
      render :template => 'articles/static' and return
    end
    @comments = @article.comments
    @comment = Comment.new
    @captcha = get_captcha
  end
  
  def post_comment
    @article = @ignite.articles.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.parent = @article
    if validate_captcha(params, @comment) && @comment.save
      flash[:notice] = 'Your comment has been posted.'
      redirect_to article_path(@article)
    else
      @comments = @article.comments
      @captcha = get_captcha
      render :action => "show"
    end
  end
  
  private
    def sticky_sort(articles)
      sorted = articles.select{|art| art.is_sticky?}
      sorted << articles.select{|art| !art.is_sticky?}
      sorted.flatten
    end
  
end
