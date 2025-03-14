class PostsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  # In PostsController
  def index
    posts = Post.published.order(published_at: :desc)

    # Apply filters
    posts = filter_by_category(posts)
    posts = filter_by_tag(posts)
    posts = filter_by_query(posts)

    # Sort posts
    posts = sort_posts(posts)

    # Eager load associations with counts
    posts = posts.includes(
      :category,
      :tags,
      :user,
      :featured_image_attachment,
      :featured_image_blob,
      user: { profile_image_attachment: :blob }
    ).left_joins(:post_views, :comments)
      .select("posts.*, COUNT(DISTINCT post_views.id) AS post_views_count, COUNT(DISTINCT comments.id) AS comments_count")
      .group("posts.id")

    # Paginate
    @pagy, @posts = pagy(posts, items: 12)

    respond_to do |format|
      format.html
      format.turbo_stream if turbo_stream_request?
    end
  end

  def show
    # Record a view for analytics if the viewer is not the author
    unless @post.user_id == current_user&.id
      PostView.create_or_find_by(
        post: @post,
        user: current_user || User.find_by(email: "anonymous@example.com") || User.first, # Fallback options
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        viewed_at: Time.current
      )
    end

    @comment = Comment.new
    @comments = @post.comments.where(parent_id: nil).includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    # Set published_at if published is checked but no date is provided
    if params[:post][:published] == "1" && params[:post][:published_at].blank?
      @post.published_at = Time.current
    end

    # Generate a slug if not provided
    if @post.slug.blank? && @post.title.present?
      @post.slug = @post.title.parameterize
    end

    # Ensure category is set (use default if needed)
    if @post.category_id.blank?
      default_category = Category.first
      @post.category_id = default_category.id if default_category
    end

    # Debug info
    Rails.logger.debug "Post params: #{post_params.inspect}"
    Rails.logger.debug "Post validation: #{@post.valid?}"
    Rails.logger.debug "Post errors: #{@post.errors.full_messages}" unless @post.valid?

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path(@post), notice: "Post was successfully created." }
        format.turbo_stream { redirect_to post_path(@post), notice: "Post was successfully created." }
      else
        # More detailed debug info on save failure
        Rails.logger.debug "Post save failed with errors: #{@post.errors.full_messages}"
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    # Handle published status changes
    if params[:post][:published] == "1" && !@post.published?
      @post.published_at = Time.current if params[:post][:published_at].blank?
    end

    # Generate a slug if not provided but title has changed
    if params[:post][:slug].blank? && params[:post][:title].present? && params[:post][:title] != @post.title
      params[:post][:slug] = params[:post][:title].parameterize
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_path(@post), notice: "Post was successfully updated." }
        format.turbo_stream { redirect_to post_path(@post), notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully deleted." }
      format.turbo_stream { redirect_to posts_path, notice: "Post was successfully deleted." }
    end
  end

  private
  def filter_by_category(posts)
    return posts unless params[:category].present?

    category = Category.find_by(slug: params[:category])
    category ? posts.where(category_id: category.id) : posts
  end

  def filter_by_tag(posts)
    return posts unless params[:tag].present?

    tag = Tag.find_by(slug: params[:tag])
    tag ? posts.joins(:tags).where(tags: { id: tag.id }) : posts
  end

  def filter_by_query(posts)
    return posts unless params[:q].present?

    posts.where("title ILIKE ? OR excerpt ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
  end

  def sort_posts(posts)
    case params[:sort]
    when "popular"
      posts.left_joins(:post_views)
          .group(:id)
          .order("COUNT(post_views.id) DESC")
    when "comments"
      posts.left_joins(:comments)
          .group(:id)
          .order("COUNT(comments.id) DESC")
    else
      posts.order(published_at: :desc)
    end
  end

  def preload_post_stats
    post_ids = @posts.map(&:id)

    # Use includes to eager load associations
    views_by_post = PostView.where(post_id: post_ids)
                            .group(:post_id)
                            .count

    comments_by_post = Comment.where(post_id: post_ids)
                              .group(:post_id)
                              .count

    # Create instance variables with default of 0
    @post_views_count = Hash.new(0).merge(views_by_post)
    @comments_count = Hash.new(0).merge(comments_by_post)
  end
  def set_post
    @post = Post.find_by(slug: params[:id]) || Post.find_by(id: params[:id])

    unless @post
      redirect_to posts_path, alert: "Post not found."
      nil
    end
  end

  def authorize_user!
    unless @post.user_id == current_user.id || current_user.admin?
      redirect_to post_path(@post), alert: "You are not authorized to perform this action."
    end
  end

  def post_params
    params.require(:post).permit(
      :title,
      :slug,
      :excerpt,
      :content,
      :published,
      :published_at,
      :featured_image,
      :category_id,
      tag_ids: []
    )
  end

  def turbo_stream_request?
    request.headers["Accept"]&.include?("text/vnd.turbo-stream.html")
  end
end
