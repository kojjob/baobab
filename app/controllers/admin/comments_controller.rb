class Admin::CommentsController < Admin::BaseController
  before_action :set_comment, only: [ :show, :approve, :reject, :destroy ]

  def index
    @filter = params[:filter] || "pending"

    @comments = if current_user.admin?
                  Comment.all
    else
                  Comment.where(post_id: current_user.posts.pluck(:id))
    end

    @comments = case @filter
    when "pending"
      @comments.pending
    when "approved"
      @comments.approved
    when "rejected"
      @comments.rejected
    when "spam"
      @comments.spam
    else
      @comments
    end

    # @pagy, @comments = pagy(@comments.includes(:user, :post).order(created_at: :desc), items: 20)
  end

  def show
  end

  def approve
    if @comment.update(status: :approved)
      redirect_to admin_comments_path, notice: "Comment was successfully approved."
    else
      redirect_to admin_comments_path, alert: "Could not approve the comment."
    end
  end

  def reject
    if @comment.update(status: :rejected)
      redirect_to admin_comments_path, notice: "Comment was successfully rejected."
    else
      redirect_to admin_comments_path, alert: "Could not reject the comment."
    end
  end

  def destroy
    @comment.destroy
    redirect_to admin_comments_path, notice: "Comment was successfully deleted."
  end

  private

  def set_comment
    @comment = if current_user.admin?
      Comment.find(params[:id])
    else
      Comment.where(post_id: current_user.posts.pluck(:id)).find(params[:id])
    end
  end
end
