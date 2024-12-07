# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Você pode substituir '*' pelos domínios específicos que deseja permitir.
    resource '/api/v1/*', headers: :any, methods: %i[get]
  end
end
