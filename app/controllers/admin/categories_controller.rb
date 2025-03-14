class Admin::CategoriesController < Admin::BaseController
  before_action :require_admin, except: [ :index, :show ]
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @categories = Category.all.order(:name)
  end

  def show
    @pagy, @posts = pagy(@category.posts.includes(:user).order(created_at: :desc), items: 15)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @category.posts.exists?
      redirect_to admin_categories_path, alert: "Cannot delete a category that has posts. Please reassign or delete the posts first."
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Category was successfully deleted."
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def require_admin
    unless current_user.admin?
      redirect_to admin_categories_path, alert: "You are not authorized to perform this action."
    end
  end
end
