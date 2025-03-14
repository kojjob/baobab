class Admin::SubscriptionsController < Admin::BaseController
  before_action :require_admin
  before_action :set_subscription, only: [ :show, :destroy ]

  def index
    @filter = params[:filter] || "confirmed"

    @subscriptions = case @filter
    when "confirmed"
      Subscription.confirmed
    when "pending"
      Subscription.pending
    when "canceled"
      Subscription.canceled
    else
      Subscription.all
    end

    @pagy, @subscriptions = pagy(@subscriptions.order(created_at: :desc), items: 20)
  end

  def show
  end

  def destroy
    @subscription.destroy
    redirect_to admin_subscriptions_path, notice: "Subscription was successfully deleted."
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
