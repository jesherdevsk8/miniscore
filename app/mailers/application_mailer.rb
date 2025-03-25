# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@jnjcodex.tech'
  layout 'mailer'
end
