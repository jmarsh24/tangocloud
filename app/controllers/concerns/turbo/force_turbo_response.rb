module Turbo
  module ForceTurboResponse
    extend ActiveSupport::Concern

    class_methods do
      def force_turbo_response(options = {})
        before_action :force_turbo_response, **options
      end
    end

    def force_turbo_response
      return if turbo_frame_request? || request.format.turbo_stream?

      redirect_back(fallback_location: root_path)
    end
  end
end
