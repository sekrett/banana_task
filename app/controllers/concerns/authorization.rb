module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize, unless: :devise_controller?

    helper_method :can?
  end

  def can?(action, resource = nil)
    current_permission.can?(get_controller_name(resource) || params[:controller], action, resource)
  end

  private
  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    @current_resource ||= get_model_class(params[:controller]).find(params[:id]) if params[:id]
  end

  def get_model_class(controller_name)
    controller_name.split('/').last.capitalize.singularize.constantize
  end

  def get_controller_name(resource)
    resource.class.to_s.downcase.pluralize if resource
  end

  def authorize
    unless current_permission.can?(params[:controller].to_sym, params[:action].to_sym, current_resource)
      redirect_to root_url, alert: t('site.not_authorized')
    end
  end
end
