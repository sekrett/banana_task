module ApplicationHelper
  def create_user_for_login
    u = User.new
    u.remember_me = true
    u
  end
end
