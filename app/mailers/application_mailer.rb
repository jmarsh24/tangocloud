# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@tangocloud.app"
  layout "mailer"
end
