class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    if cookies[:locale] &&
       I18n.available_locales.include?(cookies[:locale].to_sym)
      locale = cookies[:locale].to_sym
    else
      locale = I18n.default_locale
      cookies.permanent[:locale] = locale
    end
    I18n.locale = locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,
      :phone_number])
  end
end
