# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def flash_message(resource = nil)
    messages = ''

    %i[notice info warning error].each do |type|
      messages += "<div class=\"base-alert #{type}\" role='alert'>#{flash[type]}</div>" if flash[type]
    end

    if resource&.errors&.any?
      messages += "<div class=\'alert alert-danger\'>"
      messages += "<h5>#{pluralize(resource.errors.count, 'erro')} impediram esta operação:</h5>"
      messages += '<ul>'
      resource.errors.full_messages.each do |message|
        messages += "<li>#{message}</li>"
      end
      messages += '</ul></div>'
    end

    messages.html_safe
  end
end
