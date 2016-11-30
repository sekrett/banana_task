class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :delete_all

  validates :title, :content, presence: true

  before_create :set_published_at

  private
  def set_published_at
    self.published_at = created_at
  end
end
