class Tag < ApplicationRecord
  validates :name, presence: true

  has_many :taggings, dependent: :delete_all
  has_many :posts, through: :taggings
end
