# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to '/403' }
    end
  end

  def require_login
    return if current_user || request.path == login_path

    redirect_to login_path, alert: t('sessions.login.require')
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
