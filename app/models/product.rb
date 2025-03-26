class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :reviews
  has_one_attached :image

  validates :name, :description, :price, :inventory_quantity, presence: true

  # ✅ Allow Ransack to search these fields
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "created_at", "updated_at", "price", "category_id", "inventory_quantity"]
  end

  # ✅ Allow Ransack to access these associations
  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob"]
  end
end
