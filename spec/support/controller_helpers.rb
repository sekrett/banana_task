module ControllerHelpers
  def sign_in_user(user, model_class)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    stub_user model_class
  end

  def stub_user(model_class)
    if model_class
      allow_any_instance_of(model_class).to receive(:user_id).and_return(subject.current_user.id)
      allow_any_instance_of(model_class).to receive(:user).and_return(subject.current_user)
    end
  end
end
