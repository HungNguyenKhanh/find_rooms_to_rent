require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module FindRoomsToRent
  class Application < Rails::Application
    config.load_defaults 5.1
    I18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.generators.system_tests = nil
  end
end
