class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :province, optional: true

  validates :username, presence: true, uniqueness: true
  validates :address, presence: true, if: -> { admin? }
  validates :province, presence: true, if: -> { admin? }
  validates :city, presence: true, if: -> { admin? }
  validates :postal_code, presence: true, if: -> { admin? }

  def admin?
    self.admin == true
  end

  # Allow only these attributes to be searchable by Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      email
      username
      address
      city
      province
      postal_code
      admin
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[orders reviews]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[province]
  end
end
