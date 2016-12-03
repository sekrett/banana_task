class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include PermittedParamsController, Authorization

  def default_url_options
    if Rails.env.development? || Rails.env.test?
      { host: 'lvh.me', port: 3000 }
    elsif Rails.env.production?
      # TODO
      raise 'default_url_options not set for production'
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
