class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :rating, presence: true, inclusion: { in: 1..5 }

  def self.ransackable_associations(auth_object = nil)
    ["product", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "content", "rating", "created_at", "updated_at", "product_id", "user_id"]
  end
end
