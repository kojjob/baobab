class Comment < ApplicationRecord
  # Enums
  enum :status, { pending: 0, approved: 1, rejected: 2, spam: 3 }

  # Associations
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Validations
  validates :content, presence: true

  # Scopes
  scope :approved, -> { where(status: :approved) }
  scope :pending, -> { where(status: :pending) }
  scope :top_level, -> { where(parent_id: nil) }

  # Methods
  def approved?
    status == "approved"
  end
end
