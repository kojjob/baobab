class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post, anchor: "comment_#{@comment.id}"), notice: "Comment was posted successfully." }
        format.turbo_stream
      else
        format.html { redirect_to post_path(@post), alert: "Failed to post comment: #{@comment.errors.full_messages.to_sentence}" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment", partial: "comments/form", locals: { post: @post, comment: @comment }) }
      end
    end
  end

  def edit
    # Render edit form
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@post, anchor: "comment_#{@comment.id}"), notice: "Comment was updated successfully." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@comment, :edit), partial: "comments/form", locals: { post: @post, comment: @comment }) }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to post_path(@post), notice: "Comment was deleted successfully." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@comment)) }
    end
  end

  private

  def set_post
    @post = Post.find_by!(slug: params[:post_slug] || params[:slug])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to post_path(@post), alert: "Comment not found."
  end

  def authorize_user!
    unless @comment.user_id == current_user.id || @post.user_id == current_user.id || current_user.admin?
      redirect_to post_path(@post), alert: "You are not authorized to perform this action."
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
