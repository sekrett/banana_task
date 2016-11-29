class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :published_at, null: false, index: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
