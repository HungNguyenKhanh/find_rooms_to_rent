class OmniauthCallbackController < ApplicationController

  def create
    user = User.from_omniauth request.env["omniauth.auth"]
    if user.persisted?
      log_in user
      flash[:success] = t "login_success"
      redirect_to user
    else
      render template: "sessions/new"
      flash[:alert] = t "login_failed"
    end
  end

  def failure
    flash[:alert] = t "login_failed"
    redirect_to root_path
  end
end
