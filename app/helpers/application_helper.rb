# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def flash_message
    messages = ''
    %i[notice info warning error].each do |type|
      messages += "<div class=\"base-alert #{type}\" role='alert'>#{flash[type]}</div>" if flash[type]
    end
    messages.html_safe
  end
end
