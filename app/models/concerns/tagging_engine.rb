module TaggingEngine
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :delete_all
    has_many :tags, through: :taggings

    scope :tagged_with, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(tag_names)
    self.tags = tag_names.split(',').map do |tag_name|
      Tag.find_or_create_by!(name: tag_name.strip)
    end
  end
end
