class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.status = Comment.statuses[:pending] # Auto-approve comments later if needed

    respond_to do |format|
      if @comment.save
        # Notify post author about new comment
        # PostMailer.with(post: @post, comment: @comment).new_comment_notification.deliver_later

        format.html { redirect_to post_path(@post.slug), notice: "Your comment has been submitted and is pending approval." }
        format.js
      else
        format.html { redirect_to post_path(@post.slug), alert: "Unable to submit your comment. #{@comment.errors.full_messages.join(', ')}" }
        format.js
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    # Only allow comment creator or post author to delete
    authorize_comment_action(@comment)

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to post_path(@post.slug), notice: "Comment was successfully deleted." }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by!(slug: params[:post_slug])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def authorize_comment_action(comment)
    unless current_user.id == comment.user_id || current_user.id == @post.user_id || current_user.admin?
      raise Pundit::NotAuthorizedError, "You are not authorized to perform this action."
    end
  end
end
