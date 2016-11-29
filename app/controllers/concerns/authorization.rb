module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize, unless: :devise_controller?

    delegate :can?, to: :current_permission
    helper_method :can?
  end

  private
  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    @current_resource ||= params[:controller].capitalize.singularize.constantize.find(params[:id]) if params[:id]
  end

  def authorize
    unless current_permission.can?(params[:controller].to_sym, params[:action].to_sym, current_resource)
      redirect_to root_url, alert: t('site.not_authorized')
    end
  end
end
