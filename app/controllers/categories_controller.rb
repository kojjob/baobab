class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    @categories = Category.includes(:posts).where(posts: { published: true }).distinct
  end

    def show
      if params[:id].blank?
        redirect_to blog_posts_path, alert: "Category not found"
        return
      end

      @category = Category.find_by!(slug: params[:id])
      @posts = @category.posts.published.order(published_at: :desc).page(params[:page])
    end
end
