# frozen_string_literal: true

class SessionsController < ApplicationController
  authorize_resource class: false
  before_action :authorize

  def new; end

  def create
    generate_flash_with(authenticate)
    redirect_to @user ? '/' : "/login?email=#{params[:email]}"
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('sessions.destroy.success')
    redirect_to '/login'
  end

  private

  def authenticate
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      @user = user
      session[:user_id] = @user.id
      return true
    end

    false
  end

  def authorize
    authorize! action_name.to_sym, :session
  end
end
