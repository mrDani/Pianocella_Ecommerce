class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  def subtotal
    order_items.sum { |item| item.quantity * item.unit_price }
  end

  # validates :address, :province, :status, :total_price, presence: true

  validates :shipping_address, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :postal_code, presence: true
  validates :total_price, numericality: { greater_than: 0 }

end


