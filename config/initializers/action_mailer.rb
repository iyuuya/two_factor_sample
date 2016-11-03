# frozen_string_literal: true
Rails.application.config.action_mailer.perform_deliveries  = Settings.action_mailer.perform_deliveries
Rails.application.config.action_mailer.delivery_method     = Rails.env.test? ? :test : Settings.action_mailer.delivery_method
Rails.application.config.action_mailer.default_options     = Settings.action_mailer.default_options.to_h
Rails.application.config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_h
Rails.application.config.action_mailer.smtp_settings       = Settings.action_mailer.smtp_settings.to_h
