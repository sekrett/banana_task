json.extract! comment, :id, :post_id, :content, :created_at
json.user comment.user.name
json.editable can? :edit, comment
json.destroyable can? :destroy, comment
