class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      # Send confirmation email
      # SubscriptionMailer.with(subscription: @subscription).confirmation_email.deliver_later

      redirect_to root_path, notice: "Please check your email to confirm your subscription."
    else
      if @subscription.errors[:email].include?("has already been taken")
        redirect_to root_path, notice: "This email is already subscribed to our newsletter."
      else
        render :new
      end
    end
  end

  def confirm
    @subscription = Subscription.find_by!(token: params[:token])

    if @subscription.pending?
      @subscription.confirm!
      redirect_to root_path, notice: "Your subscription has been confirmed. Thank you!"
    else
      redirect_to root_path, notice: "This subscription is already confirmed."
    end
  end

  def unsubscribe
    @subscription = Subscription.find_by!(token: params[:token])
    @subscription.cancel!

    redirect_to root_path, notice: "You have been successfully unsubscribed."
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email)
  end
end
