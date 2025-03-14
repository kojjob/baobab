class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :publish, :unpublish ]

  def index
    @pagy, @posts = pagy(
      current_user.admin? ? Post.all.includes(:user, :category) : current_user.posts.includes(:category),
      items: 15
    )

    @posts = @posts.order(created_at: :desc)

    # Filter by status if provided
    if params[:status] == "published"
      @posts = @posts.published
    elsif params[:status] == "draft"
      @posts = @posts.where(published: false)
    end

    # Filter by category if provided
    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
    end
  end

  def show
  end

  def new
    @post = Post.new
    @categories = Category.all
    @tags = Tag.all
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      handle_tags if params[:tags].present?

      redirect_to admin_post_path(@post), notice: "Post was successfully created."
    else
      @categories = Category.all
      @tags = Tag.all
      render :new
    end
  end

  def edit
    @categories = Category.all
    @tags = Tag.all
    @selected_tags = @post.tags.pluck(:id)
  end

  def update
    if @post.update(post_params)
      # Clear existing tags and add selected ones
      @post.tags.clear
      handle_tags if params[:tags].present?

      redirect_to admin_post_path(@post), notice: "Post was successfully updated."
    else
      @categories = Category.all
      @tags = Tag.all
      @selected_tags = @post.tags.pluck(:id)
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully deleted."
  end

  def publish
    if @post.update(published: true, published_at: Time.current)
      # Notify subscribers about new post
      # SubscriptionMailer.with(post: @post).new_post_notification.deliver_later if @post.published?

      redirect_to admin_post_path(@post), notice: "Post was successfully published."
    else
      redirect_to admin_post_path(@post), alert: "Could not publish the post."
    end
  end

  def unpublish
    if @post.update(published: false)
      redirect_to admin_post_path(@post), notice: "Post was successfully unpublished."
    else
      redirect_to admin_post_path(@post), alert: "Could not unpublish the post."
    end
  end

  private

  def set_post
    @post = current_user.admin? ? Post.find(params[:id]) : current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :excerpt, :content, :category_id, :featured_image)
  end

  def handle_tags
    tag_ids = params[:tags].reject(&:blank?)
    tag_ids.each do |tag_id|
      @post.post_tags.create(tag_id: tag_id)
    end
  end
end
