# frozen_string_literal: true

class SessionsController < ApplicationController
  authorize_resource class: false
  before_action :authorize

  def new; end

  def create
    if authenticate
      session[:user_id] = @user.id
      flash[:success] = t('sessions.login.success')
      redirect_to '/'
    else
      flash[:error] = t('sessions.login.failed')
      redirect_to "/login?email=#{params[:email]}"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('sessions.logout.success')
    redirect_to '/login'
  end

  private

  def authenticate
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      @user = user
      return true
    end

    false
  end

  def authorize
    authorize! action_name.to_sym, :session
  end
end
