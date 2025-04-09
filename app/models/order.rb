class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :shipping_address, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :postal_code, presence: true

  # Allow only these attributes to be searchable by Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      name
      email
      shipping_address
      city
      province
      postal_code
      status
      total_price
      created_at
      updated_at
      user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order_items user]
  end

  before_save :calculate_taxes_and_total

  def calculate_taxes_and_total
    return unless province.present? && total_price.present?

    tax_rates = TAX_RATES[province] || { pst: 0.0, gst: 0.0 }
    self.pst = total_price * tax_rates[:pst]
    self.gst = total_price * tax_rates[:gst]
    self.total_with_taxes = total_price + pst + gst
  end
end
