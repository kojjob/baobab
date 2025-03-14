class Admin::TagsController < Admin::BaseController
  before_action :require_admin, except: [ :index, :show ]
  before_action :set_tag, only: [ :show, :edit, :update, :destroy ]

  def index
    @tags = Tag.all.order(:name)
  end

  def show
    @pagy, @posts = pagy(@tag.posts.includes(:user).order(created_at: :desc), items: 15)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to admin_tags_path, notice: "Tag was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: "Tag was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path, notice: "Tag was successfully deleted."
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def require_admin
    unless current_user.admin?
      redirect_to admin_tags_path, alert: "You are not authorized to perform this action."
    end
  end
end
