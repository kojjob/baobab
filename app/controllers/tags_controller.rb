class TagsController < ApplicationController
  def index
    @tags = Tag.includes(:posts).where(posts: { published: true }).distinct
  end

  def show
    @tag = Tag.find_by!(slug: params[:slug])
    # @pagy, @posts = pagy(@tag.posts.published.recent, items: 10)
  end
end
