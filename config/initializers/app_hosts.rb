# frozen_string_literal: true

APP_HOST = if Rails.env.production?
  "https://#{ENV.fetch('APP_HOST', '127.0.0.1:3001')}"
else
  'http://127.0.0.1:3001'
end
