class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :reviews
  has_one_attached :image

  validates :name, :price, :inventory_quantity, presence: true
end
