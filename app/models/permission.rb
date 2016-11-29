class Permission
  include PermissionEngine

  def initialize(user)
    can :posts, :read
    can :posts, [:edit, :destroy] do |post|
      post.user == user
    end
    can :posts, :create if user
  end
end
