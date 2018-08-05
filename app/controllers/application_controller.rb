class ApplicationController < ActionController::Base
  before_action :set_locale

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

  protect_from_forgery with: :exception
  include SessionsHelper
end
