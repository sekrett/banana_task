class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    if Rails.env.development?
      { host: 'lvh.me', port: 3000 }
    elsif Rails.env.production?
      # TODO
      raise 'default_url_options not set for production'
    end
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
  helper_method :permitted_attributes

  protected
  def permitted_model_name
    params[:controller].split('/').last.singularize.to_sym
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
