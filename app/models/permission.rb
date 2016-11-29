class Permission
  include PermissionEngine

  def initialize(user)
    can :posts, [:read, :edit, :destroy]
    can :posts, :create if user
  end
end
