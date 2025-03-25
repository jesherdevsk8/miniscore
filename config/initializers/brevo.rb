# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp-relay.brevo.com',
    port: 587,
    domain: ENV.fetch('DOMAIN', 'jnjcodex.tech'),
    user_name: ENV['BREVO_SMTP_USER'],
    password: ENV['BREVO_SMTP_KEY'],
    authentication: :login,
    enable_starttls_auto: true
  }
end
