class Page < ApplicationRecord
    validates :slug, presence: true, uniqueness: true
    validates :title, presence: true

  
    def self.ransackable_attributes(auth_object = nil)
      ["id", "title", "slug", "content", "created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["rich_text_content"]
      end
  end
  