class OmniauthCallbackController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback "Facebook"
  end

  def google_oauth2
    generic_callback "Google"
  end

  def failure
    flash[:alert] = t "login_failed"
    redirect_to root_path
  end

  protected

  def generic_callback provider
    user = User.from_omniauth request.env["omniauth.auth"]
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if
        is_navigational_format?
    else
      set_flash_message :alert, :failure, {kind: provider,
        reason: t("omniauth_fail_reason")}
      redirect_to new_user_registration_url
    end
  end
end
