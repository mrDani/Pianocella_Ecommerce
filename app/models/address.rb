class Address < ApplicationRecord
  belongs_to :user

  validates :street, :city, :province, :postal_code, presence: true
end
