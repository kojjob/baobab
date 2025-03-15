class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    @categories = Category.active.main_categories.sorted.includes(:subcategories)
    @featured_categories = Category.active.featured.sorted
  end

  def show
    @category = Category.active.find_by!(slug: params[:id])

    # Using pagy for pagination instead of .page
    @pagy_posts, @posts = pagy(@category.posts.published.order(published_at: :desc))

    # For products, use pagy with a different per_page count
    @pagy_products, @products = pagy(@category.products.active.includes(:merchant), items: 24)

    @subcategories = @category.subcategories.active.sorted

    # For breadcrumbs
    @ancestors = @category.ancestors
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, alert: "Category not found"
  end
end
