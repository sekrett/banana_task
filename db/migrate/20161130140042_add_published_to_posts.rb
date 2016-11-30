class AddPublishedToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :published, :boolean, null: false, default: true
    add_index :posts, :published
  end
end
