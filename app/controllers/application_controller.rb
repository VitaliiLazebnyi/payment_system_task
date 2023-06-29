# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  rescue_from CanCan::AccessDenied, with: :access_denied
  rescue_from ArgumentError, with: :argument_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :internal_error

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def access_denied
    respond_to do |format|
      format.json { head :forbidden }
      format.html { render file: Rails.public_path.join('403.html').to_s, layout: false, status: :forbidden }
    end
  end

  def argument_error(exception)
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :bad_request }
      format.html { render file: Rails.public_path.join('400.html').to_s, layout: false, status: :bad_request }
    end
  end

  def not_found
    respond_to do |format|
      format.json { head :not_found }
      format.html { render file: Rails.public_path.join('404.html').to_s, layout: false, status: :not_found }
    end
  end

  def internal_error
    respond_to do |format|
      format.json { head :not_found }
      format.html do
        render file: Rails.public_path.join('500.html').to_s, layout: false, status: :internal_server_error
      end
    end
  end

  def require_login
    return if current_user || request.path == login_path

    redirect_to login_path, flash: { error: t('sessions.create.require') }
  end

  def generate_flash_with(success)
    flash.clear

    if success
      flash[:success] = t("#{controller_name}.#{action_name}.success")
    else
      flash[:error] = t("#{controller_name}.#{action_name}.failed")
    end
  end

  helper_method :current_user
end
