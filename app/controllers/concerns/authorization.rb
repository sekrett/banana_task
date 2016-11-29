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

  def authorize
    unless current_permission.can?(params[:controller].to_sym, params[:action].to_sym)
      redirect_to root_url, alert: t('site.not_authorized')
    end
  end
end
