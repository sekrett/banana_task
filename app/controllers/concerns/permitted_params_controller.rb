module PermittedParamsController
  extend ActiveSupport::Concern

  included do
    helper_method :permitted_attributes
  end

  def memoize_permitted_params
    @permitted_params ||= PermittedParams.new(params, self, permitted_model_name)
  end

  def permitted_params
    memoize_permitted_params
    @permitted_params.permitted_params
  end

  def permitted_attributes(model_name)
    memoize_permitted_params
    @permitted_params.permitted_attributes(model_name)
  end

  protected
  def permitted_model_name
    params[:controller].split('/').last.singularize.to_sym
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
