class ApplicationMailer < ActionMailer::Base
  default from: "info@tangocloud.app"
  layout "mailer"

  def send_to(user:)
    I18n.with_locale(user.locale) do
      address = user.email
      if user.username.present?
        address = email_address_with_name(user.email, user.display_name)
      end
      mail to: address
    end
  end
end
