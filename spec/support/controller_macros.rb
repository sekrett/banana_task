module ControllerMacros
  def login_user(model_class = nil)
    before(:each) { self.sign_in_user(create(:user), model_class) }
  end
end
