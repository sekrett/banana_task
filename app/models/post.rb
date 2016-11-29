class Post < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true

  before_create :set_published_at

  private
  def set_published_at
    self.published_at = created_at
  end
end
