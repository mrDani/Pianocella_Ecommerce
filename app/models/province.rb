class Province < ApplicationRecord
    has_many :users

    def self.ransackable_attributes(auth_object = nil)
      %w[id name pst gst hst created_at updated_at]
    end
end
