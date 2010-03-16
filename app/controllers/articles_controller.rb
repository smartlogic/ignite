class ArticlesController < BaseUserController
  include ReCaptcha::ViewHelper
  
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
  
  def top_news
    @article = @ignite.articles.find(:first, :conditions => {:is_news => true}, :order => "created_at DESC")
    if @article
      @comments = @article.comments
      @comment = Comment.new
      @captcha = get_captcha
      render :action => 'show'
    else
      redirect_to :action => 'index'
    end
  end

  def show
    @article = @ignite.articles.find(params[:id])
    @comments = @article.comments
    @comment = Comment.new
    @captcha = get_captcha
  end
  
  def post_comment
    @article = @ignite.articles.find(params[:id])
    if !@article.comments_allowed?
      flash[:error] = "This post does not allow comments"
      redirect_to article_path(@article)
      return
    end
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
