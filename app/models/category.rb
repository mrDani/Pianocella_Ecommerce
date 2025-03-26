class Category < ApplicationRecord
    has_many :products, dependent: :destroy
    validates :name, presence: true, uniqueness: true


    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end
    
    def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
    end
  end
  