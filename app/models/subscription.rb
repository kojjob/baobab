class Subscription < ApplicationRecord
  # Enums
  enum :status, { pending: 0, confirmed: 1, canceled: 2 }

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_token, on: :create, if: -> { token.blank? }

  # Methods
  def confirm!
    update(status: :confirmed)
  end

  def cancel!
    update(status: :canceled)
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(32)
  end
end
