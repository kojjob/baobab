class MerchantPolicy < ApplicationPolicy
  def index?
    true # Anyone can view the index
  end

  def show?
    true # Anyone can view merchant details
  end

  def create?
    user.present? # Any logged-in user can create a merchant
  end

  def update?
    return false unless user.present?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    return false unless user.present?
    user.admin? || record.user_id == user.id
  end

  def toggle_feature?
    # Only admins or premium users can toggle featured status
    user.present? && (user.respond_to?(:admin?) && user.admin? || user.respond_to?(:premium?) && user.premium?)
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(user_id: user&.id)
      end
    end
  end
end
