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
end
