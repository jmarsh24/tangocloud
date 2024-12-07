module DetectDevice
  extend ActiveSupport::Concern

  included do
    before_action :set_variant
  end

  private

  def set_variant
    # case request.user_agent
    # when /iPhone/
    #  request.variant = :phone
    # when /iPad/
    #  request.variant = :tablet
    # end

    browser = Browser.new(request.user_agent)
    request.variant = :mobile if turbo_native_app? || browser.device.mobile?
  end
end
