class MerchantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_merchant, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_merchant, except: [ :index, :new, :create ]

  # GET /merchants
  def index
    # Use Pundit's policy_scope instead of directly authorizing
    @merchants = policy_scope(Merchant)
                .includes(:category, :products, :reviews, logo_attachment: :blob)
                .order(created_at: :desc)

    @pagy, @merchants = pagy(@merchants)
  end

  # GET /merchants/1
  def show
    @products = @merchant.products.active.includes(image_attachment: :blob).limit(12)
    @reviews = @merchant.reviews.includes(user: { avatar_attachment: :blob }).order(created_at: :desc).limit(5)
  end

  # GET /merchants/new
  def new
    authorize Merchant
    @merchant = Merchant.new
  end

  # GET /merchants/1/edit
  def edit
  end

  # POST /merchants
  def create
    authorize Merchant
    @merchant = Merchant.new(merchant_params)
    @merchant.user = current_user unless @merchant.user_id

    # Process JSON attributes
    process_array_and_json_attributes

    if @merchant.save
      process_address_params if params[:address].present?
      respond_to do |format|
        format.html { redirect_to merchant_path(@merchant), notice: "Merchant was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Merchant was successfully created." }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /merchants/1
  def update
    # Process JSON attributes
    process_array_and_json_attributes

    # Handle document removal if requested
    remove_documents if params[:merchant][:remove_documents].present?

    # Handle logo removal if requested
    @merchant.logo.purge if params[:merchant][:remove_logo] == "true"

    # Handle cover photo removal if requested
    @merchant.cover_photo = nil if params[:merchant][:remove_cover_photo] == "true"

    if @merchant.update(merchant_params)
      process_address_params if params[:address].present?
      respond_to do |format|
        format.html { redirect_to merchant_path(@merchant), notice: "Merchant was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Merchant was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1
  def destroy
    @merchant.destroy
    respond_to do |format|
      format.html { redirect_to merchants_path, notice: "Merchant was successfully deleted." }
      format.turbo_stream { flash.now[:notice] = "Merchant was successfully deleted." }
    end
  end

  # POST /merchants/1/toggle_feature
  def toggle_feature
    # No need to find the merchant again, set_merchant already did that
    if @merchant.update(featured: !@merchant.featured)
      respond_to do |format|
        format.html { redirect_to merchant_path(@merchant), notice: "Merchant feature status updated." }
        format.turbo_stream { flash.now[:notice] = "Merchant feature status updated." }
      end
    else
      respond_to do |format|
        format.html { redirect_to merchant_path(@merchant), alert: "Could not update feature status." }
        format.turbo_stream { flash.now[:alert] = "Could not update feature status." }
      end
    end
  end

  # DELETE /merchants/1/remove_document
  def remove_document
    @merchant = Merchant.find(params[:id])
    authorize @merchant, :update?

    document = ActiveStorage::Attachment.find(params[:document_id])
    document.purge if document && document.record == @merchant

    respond_to do |format|
      format.html { redirect_to edit_merchant_path(@merchant), notice: "Document removed." }
      format.turbo_stream { flash.now[:notice] = "Document removed." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_merchant
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.nil?
      flash[:alert] = "Merchant not found"
      redirect_to merchants_path
    end
  end

  def authorize_merchant
    authorize @merchant if @merchant.present?
  end

  # Apply scopes based on filter params
  def apply_scopes(scope)
    scope = scope.search_by_name_and_description(params[:search]) if params[:search].present?
    scope = scope.by_category(params[:category_id]) if params[:category_id].present?
    scope = scope.by_business_type(params[:business_type]) if params[:business_type].present?
    scope = scope.where(verification_status: params[:verification_status]) if params[:verification_status].present?
    scope = scope.by_subscription(params[:subscription_level]) if params[:subscription_level].present?
    scope = scope.active if params[:active] == "1"
    scope = scope.verified if params[:verified] == "1"
    scope = scope.featured if params[:featured] == "1"

    # Apply sorting
    scope = apply_sorting(scope)

    scope
  end

  def apply_sorting(scope)
    case params[:sort]
    when "created_at_desc"
      scope.order(created_at: :desc)
    when "created_at_asc"
      scope.order(created_at: :asc)
    when "name_asc"
      scope.order(name: :asc)
    when "name_desc"
      scope.order(name: :desc)
    when "products_count_desc"
      scope.left_joins(:products).group(:id).order("COUNT(products.id) DESC")
    when "average_rating_desc"
      scope.left_joins(products: :reviews).group(:id).order("AVG(reviews.rating) DESC NULLS LAST")
    else
      scope.order(created_at: :desc)
    end
  end

  # Process array and JSON attributes before saving
  def process_array_and_json_attributes
    # Convert comma-separated service areas to array
    if params[:merchant][:service_areas].present?
      params[:merchant][:service_areas] = params[:merchant][:service_areas].split(",").map(&:strip)
    end

    # Convert comma-separated keywords to array
    if params[:merchant][:keywords].present?
      params[:merchant][:keywords] = params[:merchant][:keywords].split(",").map(&:strip)
    end

    # Process payment methods
    params[:merchant][:payment_methods] ||= []

    # Process business hours
    process_business_hours if params[:merchant][:business_hours].present?

    # Process bank account details
    if params[:merchant][:bank_account].present?
      params[:merchant][:bank_account] = params[:merchant][:bank_account].to_h
    end

    # Process mobile money details
    if params[:merchant][:mobile_money_details].present?
      params[:merchant][:mobile_money_details] = params[:merchant][:mobile_money_details].to_h
    end

    # Process social media links
    if params[:merchant][:social_media].present?
      params[:merchant][:social_media] = params[:merchant][:social_media].to_h
    end
  end

  # Process business hours data
  def process_business_hours
    hours = {}

    params[:merchant][:business_hours].each do |day, values|
      hours[day] = {
        "open" => values[:open] == "true",
        "open_time" => values[:open_time],
        "close_time" => values[:close_time]
      }
    end

    params[:merchant][:business_hours] = hours
  end

  # Process address parameters
  def process_address_params
    address_params = params[:address].permit(
      :street_address, :address_line_2, :city, :region,
      :postal_code, :directions, :address_type
    )

    # Find existing address or create new one
    address = @merchant.addresses.find_or_initialize_by(address_type: address_params[:address_type])
    address.update(address_params)
  end

  # Remove documents if requested
  def remove_documents
    document_ids = params[:merchant][:remove_documents].split(",").map(&:to_i)
    document_ids.each do |document_id|
      document = ActiveStorage::Attachment.find_by(id: document_id)
      document.purge if document && document.record == @merchant
    end
  end

  # Only allow a list of trusted parameters through.
  def merchant_params
    params.require(:merchant).permit(
      :name, :description, :phone, :email, :location, :logo, :active,
      :verified, :user_id, :registration_number, :tax_id, :business_type,
      :year_established, :employee_count, :delivery_radius, :delivery_fee,
      :minimum_order, :preparation_time, :commission_rate, :payout_schedule,
      :verification_status, :featured, :subscription_level, :subscription_expires_at,
      :slug, :meta_title, :meta_description, :website, :email, :contact_person,
      :category_id, :cover_photo, :return_policy, :shipping_policy,
      # JSON fields are handled separately
      :business_hours, :service_areas, :payment_methods, :bank_account,
      :mobile_money_details, :social_media, :keywords,
      # Attachments
      verification_documents: []
    )
  end
end
