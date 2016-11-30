class Permission
  include PermissionEngine

  COMMENT_MANAGEABLE_INTERVAL = 15.minutes

  def initialize(user)
    can :posts, :read
    can :posts, [:edit, :destroy] do |post|
      post.user == user
    end
    can :posts, :create if user

    can :comments, :read
    can :comments, :manage do |comment|
      comment.user == user && comment.created_at > COMMENT_MANAGEABLE_INTERVAL.ago
    end
  end
end
