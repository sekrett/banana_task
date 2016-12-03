class Permission
  include PermissionEngine

  COMMENT_MANAGEABLE_INTERVAL = 15.minutes

  def initialize(user)
    can :posts, :read
    can :posts, [:edit, :destroy] do |post|
      post.user == user
    end
    can :posts, :create if user

    comment_controllers = ['api/v1/comments', :comments]

    can comment_controllers, :read
    can comment_controllers, :create if user
    can comment_controllers, [:edit, :destroy] do |comment|
      comment.user == user && comment.created_at > COMMENT_MANAGEABLE_INTERVAL.ago
    end
  end
end
