# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authorize

  def new; end

  def create
    if authenticate
      session[:user_id] = @user.id
      flash[:notice] = t('.sessions.login.success')
      redirect_to '/'
    else
      flash[:notice] = t('.sessions.login.failed')
      redirect_to "/login?email=#{params[:email]}"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = t('.sessions.logout.success')
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
    authorize! action_name, :session
  end
end
