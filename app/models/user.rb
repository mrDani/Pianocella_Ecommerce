class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :reviews
  validates :username, presence: true, uniqueness: true
  validates :address, presence: true
  validates :province, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  
  def admin?
    self.admin == true
  end
end
