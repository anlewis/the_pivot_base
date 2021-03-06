class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :set_cart, :set_categories, :authorize!

  def current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def authorize!
    current_permission = PermissionsService.new(current_user, params['controller'], params['action'])
    not_found unless current_permission.authorized?
  end

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def set_categories
    @categories = Category.all
  end

  private
    def require_admin
      not_found unless current_user.current_admin?
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end
end
