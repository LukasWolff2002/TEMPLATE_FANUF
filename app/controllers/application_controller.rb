class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
  helper_method :logged_in?

  private

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      elsif cookies.signed[:user_id]
        user = User.find_by(id: cookies.signed[:user_id])
        session[:user_id] = user.id if user
        user
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Debes iniciar sesión para acceder"
      redirect_to login_path
    end
  end
end