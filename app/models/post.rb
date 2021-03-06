class Post < ApplicationRecord
  include TaggingEngine

  belongs_to :user
  has_many :comments, dependent: :delete_all

  validates :title, :content, presence: true

  before_create :set_published_at

  scope :published, -> { where(published: true) }

  private
  def set_published_at
    self.published_at = created_at.change(sec: 0)
  end
end
